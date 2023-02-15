//
//  ChatMessagesView.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

import SwiftUI

struct ChatMessagesView: View {
    @State private var chatMessages: [ChatMessage] = ChatMessage.sampleMessages
    @State private var messageText: String = ""
    @State private var isSendButtonTapped = false
    
    var body: some View {
        VStack(spacing: 0) {
            messagesView
                .overlay(buttonPannelView, alignment: .bottom)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var messagesView: some View {
        ScrollView {
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
    
    private var buttonPannelView: some View {
        HStack(spacing: 0) {
            TextField("Enter a message", text: $messageText)
                .padding(.bottom)
            
            Button {
                withAnimation {
                    isSendButtonTapped = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isSendButtonTapped = false
                    }
                }

                chatMessages.append(ChatMessage(id: UUID().uuidString, content: "New message \(UUID().uuidString)", dateCreated: Date(), sender: .user))
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

extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .chatGPT),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .chatGPT),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .chatGPT),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .chatGPT),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .chatGPT),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .chatGPT),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message14", dateCreated: Date(), sender: .chatGPT)
    ]
}



