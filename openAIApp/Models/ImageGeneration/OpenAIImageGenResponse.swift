//
//  OpenAIImageGenResponse.swift
//  openAIApp
//
//  Created by Eugene Ned on 18.02.2023.
//

import Foundation

struct OpenAIImageGenResponse: Decodable {
    let created: Int
    let data: [OpenAIImageGenData]
}

struct OpenAIImageGenData: Decodable {
    let url: String
}
