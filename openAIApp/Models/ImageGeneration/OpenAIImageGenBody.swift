//
//  OpenAIImageGenerationBody.swift
//  openAIApp
//
//  Created by Eugene Ned on 18.02.2023.
//

struct OpenAIImageGenBody: Encodable {
    let model: String
    let prompt: String
    let response_format: String?
}
