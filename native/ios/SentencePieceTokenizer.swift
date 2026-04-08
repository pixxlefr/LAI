// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

import Foundation

struct TokenizerData: Codable {
    let vocab: [String: Int]
    let specialTokens: [String]?

    enum CodingKeys: String, CodingKey {
        case vocab
        case specialTokens = "special_tokens"
    }
}

final class SentencePieceTokenizer {
    private let processor: SentencePieceWrapper
    private let vocab: [String: Int]
    private let reverseVocab: [Int: String]

    let padTokenId: Int
    let unkTokenId: Int
    let bosTokenId: Int
    let eosTokenId: Int
    let userTokenId: Int
    let factsTokenId: Int
    let answerTokenId: Int

    let stopTokenIds: Set<Int>

    init(modelPath: String, vocabPath: String) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: vocabPath))
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(TokenizerData.self, from: data)
        self.vocab = decoded.vocab
        self.reverseVocab = Dictionary(uniqueKeysWithValues: decoded.vocab.map { ($1, $0) })

        var error: NSError?
        guard let processor = SentencePieceWrapper(modelPath: modelPath, error: &error) else {
            throw error ?? NSError(domain: "SentencePiece", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load SentencePiece model"])
        }
        self.processor = processor

        self.padTokenId = SentencePieceTokenizer.resolveId("[PAD]", vocab: vocab, processor: processor)
        self.unkTokenId = SentencePieceTokenizer.resolveId("[UNK]", vocab: vocab, processor: processor)
        self.bosTokenId = SentencePieceTokenizer.resolveId("[BOS]", vocab: vocab, processor: processor)
        self.eosTokenId = SentencePieceTokenizer.resolveId("[EOS]", vocab: vocab, processor: processor)
        self.userTokenId = SentencePieceTokenizer.resolveId("[USER]", vocab: vocab, processor: processor)
        self.factsTokenId = SentencePieceTokenizer.resolveId("[FACTS]", vocab: vocab, processor: processor)
        self.answerTokenId = SentencePieceTokenizer.resolveId("[ANSWER]", vocab: vocab, processor: processor)

        self.stopTokenIds = [eosTokenId, userTokenId, answerTokenId]
    }

    func encode(_ text: String, addBos: Bool, addEos: Bool, maxLength: Int? = nil) -> [Int] {
        var ids = processor.encode(text).map { $0.intValue }

        if addBos {
            ids.insert(bosTokenId, at: 0)
        }
        if addEos {
            ids.append(eosTokenId)
        }
        if let maxLength = maxLength, ids.count > maxLength {
            ids = Array(ids.prefix(maxLength))
        }

        return ids
    }

    func decode(_ ids: [Int], skipSpecialTokens: Bool = true) -> String {
        var tokens = ids
        if skipSpecialTokens {
            let specials: Set<Int> = [
                padTokenId,
                unkTokenId,
                bosTokenId,
                eosTokenId,
                userTokenId,
                factsTokenId,
                answerTokenId
            ]
            tokens = tokens.filter { !specials.contains($0) }
        }

        if tokens.isEmpty {
            return ""
        }

        let nsTokens = tokens.map { NSNumber(value: $0) }
        return processor.decode(nsTokens)
    }

    private static func resolveId(_ token: String, vocab: [String: Int], processor: SentencePieceWrapper) -> Int {
        if let id = vocab[token] {
            return id
        }
        let fallback = processor.pieceId(token)
        return fallback
    }
}
