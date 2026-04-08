// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

import Foundation
import Capacitor

@objc(LaiModel)
public class LaiModelPlugin: CAPPlugin {
    private let inference = LAIInference.shared
    private var modelPath: String?
    private var tokenizerModelPath: String?
    private var vocabPath: String?

    @objc func load(_ call: CAPPluginCall) {
        do {
            guard let modelPath = Bundle.main.path(forResource: "lai_v3_mobile", ofType: "ptl"),
                  let tokenizerModelPath = Bundle.main.path(forResource: "tokenizer_spm", ofType: "model"),
                  let vocabPath = Bundle.main.path(forResource: "tokenizer_spm", ofType: "json") else {
                call.reject("Model or tokenizer files not found in bundle")
                return
            }

            try inference.load(modelPath: modelPath, tokenizerModelPath: tokenizerModelPath, vocabPath: vocabPath)
            self.modelPath = modelPath
            self.tokenizerModelPath = tokenizerModelPath
            self.vocabPath = vocabPath
            call.resolve()
        } catch {
            call.reject(error.localizedDescription)
        }
    }

    @objc func generate(_ call: CAPPluginCall) {
        guard let prompt = call.getString("prompt") else {
            call.reject("Missing prompt")
            return
        }

        let maxNewTokens = call.getInt("maxNewTokens") ?? GenerationConfig.default.maxNewTokens
        let temperature = call.getFloat("temperature") ?? GenerationConfig.default.temperature
        let topK = call.getInt("topK") ?? GenerationConfig.default.topK
        let repetitionPenalty = call.getFloat("repetitionPenalty") ?? GenerationConfig.default.repetitionPenalty

        let config = GenerationConfig(
            maxNewTokens: maxNewTokens,
            temperature: temperature,
            topK: topK,
            repetitionPenalty: repetitionPenalty
        )

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                if self.modelPath == nil || self.tokenizerModelPath == nil || self.vocabPath == nil {
                    let callCopy = call
                    DispatchQueue.main.async {
                        callCopy.reject("Model not loaded. Call load() first.")
                    }
                    return
                }

                let text = try self.inference.generate(prompt: prompt, config: config)
                DispatchQueue.main.async {
                    call.resolve(["text": text])
                }
            } catch {
                DispatchQueue.main.async {
                    call.reject(error.localizedDescription)
                }
            }
        }
    }
}
