//
//  ChatViewModel.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

import Foundation
import Combine

class ChatMessagesViewModel: ObservableObject {
    @Published private(set) var chatMessages: [ChatMessage] = []
    @Published var messageText: String = ""
    
    @Published var isLoadingResponse = false
    @Published var showAlert = false
    
    private let openAIService = OpenAIService()
    private var cancellables = Set<AnyCancellable>()
    
    func send(message: String) {
        guard !message.isEmpty else {
            return
        }
        isLoadingResponse = true
        let userMessage = ChatMessage(id: UUID().uuidString, content: message, dateCreated: Date(), sender: .user)
        chatMessages.append(userMessage)
        
        openAIService.send(message: message)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoadingResponse = false
                case .failure:
                    self?.showAlert = true
                    self?.chatMessages.removeAll(where: { $0.content == userMessage.content })
                    self?.isLoadingResponse = false
                }
            }, receiveValue: { [weak self] response in
                guard let text = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {
                    return
                }
                let chatGPTMessage = ChatMessage(id: response.id, content: text, dateCreated: Date(), sender: .chatGPT)
                self?.chatMessages.append(chatGPTMessage)
            })
            .store(in: &cancellables)
        
        messageText = ""
    }
}

extension ChatMessagesViewModel: EmptyStatePointViewDelegate {
    func didTapOnExample(text: String) {
        self.send(message: text)
    }
}

