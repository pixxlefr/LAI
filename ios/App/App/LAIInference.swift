// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

import Foundation

struct GenerationConfig {
    let maxNewTokens: Int
    let temperature: Float
    let topK: Int
    let repetitionPenalty: Float

    static let `default` = GenerationConfig(
        maxNewTokens: 50,
        temperature: 0.7,
        topK: 40,
        repetitionPenalty: 1.3
    )
}

final class LAIInference {
    static let shared = LAIInference()

    private var module: TorchModule?
    private var tokenizer: SentencePieceTokenizer?
    private let maxContextLength = 1024

    private init() {}

    func load(modelPath: String, tokenizerModelPath: String, vocabPath: String) throws {
        guard FileManager.default.fileExists(atPath: modelPath) else {
            throw NSError(domain: "LAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file not found"])
        }

        guard FileManager.default.fileExists(atPath: tokenizerModelPath) else {
            throw NSError(domain: "LAI", code: -2, userInfo: [NSLocalizedDescriptionKey: "Tokenizer model not found"])
        }

        guard FileManager.default.fileExists(atPath: vocabPath) else {
            throw NSError(domain: "LAI", code: -3, userInfo: [NSLocalizedDescriptionKey: "Tokenizer vocab not found"])
        }

        let module = TorchModule(fileAtPath: modelPath)
        guard module != nil else {
            throw NSError(domain: "LAI", code: -4, userInfo: [NSLocalizedDescriptionKey: "Failed to load model"])
        }

        self.module = module
        self.tokenizer = try SentencePieceTokenizer(modelPath: tokenizerModelPath, vocabPath: vocabPath)
    }

    func generate(prompt: String, config: GenerationConfig = .default) throws -> String {
        guard let module = module, let tokenizer = tokenizer else {
            throw NSError(domain: "LAI", code: -5, userInfo: [NSLocalizedDescriptionKey: "Model not loaded"])
        }

        let promptIds = tokenizer.encode(prompt, addBos: true, addEos: false)
        let generated = try generateTokens(
            module: module,
            inputIds: promptIds,
            config: config,
            stopTokenIds: tokenizer.stopTokenIds
        )

        let newTokens = Array(generated.dropFirst(promptIds.count))
        return tokenizer.decode(newTokens)
    }

    private func generateTokens(
        module: TorchModule,
        inputIds: [Int],
        config: GenerationConfig,
        stopTokenIds: Set<Int>
    ) throws -> [Int] {
        var generatedIds = inputIds

        for _ in 0..<config.maxNewTokens {
            let contextIds = Array(generatedIds.suffix(maxContextLength))
            let shape = [1, contextIds.count]
            let inputTensor = contextIds.withUnsafeBufferPointer { ptr -> TorchTensor in
                return TorchTensor.fromBlob(
                    ptr.baseAddress!,
                    shape: shape.map { NSNumber(value: $0) },
                    dtype: .int64
                )
            }

            guard let outputTensor = module.forward([inputTensor])?.first else {
                throw NSError(domain: "LAI", code: -6, userInfo: [NSLocalizedDescriptionKey: "Forward pass failed"])
            }

            let logits = extractLogits(from: outputTensor)
            let nextToken = sample(
                logits: logits,
                temperature: config.temperature,
                topK: config.topK,
                repetitionPenalty: config.repetitionPenalty,
                previousTokens: generatedIds
            )

            if stopTokenIds.contains(nextToken) {
                break
            }

            generatedIds.append(nextToken)
        }

        return generatedIds
    }

    private func extractLogits(from tensor: TorchTensor) -> [Float] {
        let dataPtr = tensor.data()
        let vocabSize = 16000
        let floatPtr = dataPtr.assumingMemoryBound(to: Float.self)
        let seqLen = Int(tensor.shape[1].intValue)
        let lastTokenOffset = (seqLen - 1) * vocabSize

        var logits: [Float] = []
        logits.reserveCapacity(vocabSize)
        for i in 0..<vocabSize {
            logits.append(floatPtr[lastTokenOffset + i])
        }

        return logits
    }

    private func sample(
        logits: [Float],
        temperature: Float,
        topK: Int,
        repetitionPenalty: Float,
        previousTokens: [Int]
    ) -> Int {
        var adjustedLogits = logits

        for token in previousTokens.suffix(64) {
            if token < adjustedLogits.count {
                adjustedLogits[token] /= repetitionPenalty
            }
        }

        adjustedLogits = adjustedLogits.map { $0 / temperature }

        let maxLogit = adjustedLogits.max() ?? 0
        let expLogits = adjustedLogits.map { exp($0 - maxLogit) }
        let sumExp = expLogits.reduce(0, +)
        let probs = expLogits.map { $0 / sumExp }

        let topKIndices = probs.enumerated()
            .sorted { $0.element > $1.element }
            .prefix(topK)
            .map { $0.offset }

        let randomValue = Float.random(in: 0..<1)
        var cumulative: Float = 0
        for idx in topKIndices {
            cumulative += probs[idx]
            if randomValue < cumulative {
                return idx
            }
        }

        return topKIndices.first ?? 0
    }
}
