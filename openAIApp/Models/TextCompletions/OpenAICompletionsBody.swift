//
//  OpenAICompletions.swift
//  openAIApp
//
//  Created by Eugene Ned on 16.02.2023.
//

import Foundation

struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let max_tokens: Int
    let temperature: Float?
}
