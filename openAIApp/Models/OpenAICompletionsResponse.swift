//
//  OpenAICompletionsResponse.swift
//  openAIApp
//
//  Created by Eugene Ned on 16.02.2023.
//

import Foundation

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionsChoice]
}

struct OpenAICompletionsChoice: Decodable {
    let text: String
}


