//
//  ChatMessagesView.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

import SwiftUI
import Combine

struct ChatMessagesView: View {
    @State private var chatMessages: [ChatMessage] = []//ChatMessage.sampleMessages
    @State private var messageText: String = ""
    @State private var isSendButtonTapped = false
    
    @State var cancellables = Set<AnyCancellable>()
    
    let openAIService = OpenAIService()
    
    var body: some View {
        VStack(spacing: 0) {
            messagesView
                .overlay(buttonPannelView, alignment: .bottom)
        }
        
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                if chatMessages.isEmpty {
                    ChatEmptyStateView(delegate: self)
                        .padding(.horizontal, 4)
                        .padding(.bottom, Constants.scrollViewBottomPadding)
                } else {
                    ScrollViewReader { scrollView in
                        ForEach(chatMessages, id: \.id) { message in
                            SingleMessageView(forMessage: message.content, sentAt: message.dateCreated, from: message.sender)
                                .id(message.id)
                                .padding(.bottom, message == chatMessages.last ? Constants.scrollViewBottomPadding : 0)
                        }
                        .onAppear {
                            scrollView.scrollTo(chatMessages.last?.id, anchor: .bottom)
                        }
                        .onChange(of: chatMessages) { _ in
                            withAnimation {
                                scrollView.scrollTo(chatMessages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
    
    private var buttonPannelView: some View {
        HStack(spacing: 0) {
            TextField("Enter a message", text: $messageText)
                .padding(.bottom)
            
            Button {
                if !messageText.isEmpty {
                    withAnimation {
                        isSendButtonTapped = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isSendButtonTapped = false
                        }
                    }
                    send(message: messageText)
                }
            } label: {
                Image(systemName: SFSymbols.send)
                    .resizable()
                    .frame(width: Constants.sendButtonSize, height: Constants.sendButtonSize)
                    .tint(Color(.systemPurple))
                    .rotationEffect(.degrees(isSendButtonTapped ? 360 : 0))
                    .scaleEffect(isSendButtonTapped ? 1.1 : 1.0)
            }
            .animation(isSendButtonTapped ? Animation.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5) : nil)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.bottomContainerCornerRadius))
    }
    
    private func send(message: String) {
        let userMessage = ChatMessage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .user)
        chatMessages.append(userMessage)
        
        openAIService.send(message: messageText).sink { error in
            print(error)
        } receiveValue: { response in
            guard let text = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let chatGPTMessage = ChatMessage(id: response.id, content: text, dateCreated: Date(), sender: .chatGPT)
            chatMessages.append(chatGPTMessage)
        }
        .store(in: &cancellables)
        messageText = ""
    }
    
    private enum Constants {
        static let sendButtonSize: CGFloat = 32
        static let bottomContainerCornerRadius: CGFloat = 16
        static let scrollViewBottomPadding: CGFloat = 75
    }
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView()
    }
}

extension ChatMessagesView: EmptyStatePointViewDelegate {
    
    func didTapOnExample(text: String) {
        openAIService.send(message: text).sink { error in
            print(error)
        } receiveValue: { response in
            guard let text = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let chatGPTMessage = ChatMessage(id: response.id, content: text, dateCreated: Date(), sender: .chatGPT)
            chatMessages.append(chatGPTMessage)
        }
        .store(in: &cancellables)
    }
}


