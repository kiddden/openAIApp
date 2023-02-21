//
//  ChatMessageModel.swift
//  openAIApp
//
//  Created by Eugene Ned on 09.02.2023.
//

import Foundation

enum MessageSender {
    case user, ai
}

struct Message: Equatable {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}
