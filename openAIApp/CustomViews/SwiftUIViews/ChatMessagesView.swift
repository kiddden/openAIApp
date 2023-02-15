//
//  ChatMessagesView.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

import SwiftUI

struct ChatMessagesView: View {
    @State var chatMessages: [ChatMessage] = ChatMessage.sampleMessages
    @State var messageText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            messagesView
                .overlay(buttonPannelView, alignment: .bottom)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(chatMessages, id: \.id) { message in
                SingleMessageView(forMessage: message.content, sentAt: message.dateCreated, from: message.sender)
            }
        }
    }
    
    private var buttonPannelView: some View {
        HStack(spacing: 0) {
            TextField("Enter a message", text: $messageText)
                .padding(.bottom)
            //                .background(Color.red)
            Button {
                print("Sender")
            } label: {
                Image(systemName: SFSymbols.send)
                    .resizable()
                    .frame(width: Constants.sendButtonSize, height: Constants.sendButtonSize)
                    .tint(Color(.systemPurple))
            }
        }
        .padding()
        //        .clipShape(RoundedRectangle(cornerRadius: 16))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private enum Constants {
        static let sendButtonSize: CGFloat = 32
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
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message sample message", dateCreated: Date(), sender: .chatGPT)
    ]
}



