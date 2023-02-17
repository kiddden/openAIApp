//
//  ChatMessagesView.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

import SwiftUI
import Combine

struct ChatMessagesView: View {
    @State private var chatMessages: [ChatMessage] = []
    @State private var messageText: String = ""
    
    @State private var isSendButtonTapped = false
    @State private var isLoadingResponse = false
    
    @State private var showAlert = false
    
    @State private var cancellables = Set<AnyCancellable>()
    
    private let openAIService = OpenAIService()
    
    var body: some View {
        VStack(spacing: 0) {
            messagesView
                .overlay(buttonPannelView, alignment: .bottom)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Something went wrong"),
                  message: Text("Please try again"),
                  dismissButton: .default(Text("Got it!"), action: {
                withAnimation {
                    isLoadingResponse = false
                    showAlert = false
                }
            }))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                VStack(spacing: 0) {
                    if chatMessages.isEmpty {
                        ChatEmptyStateView(delegate: self)
                            .padding(.horizontal, 4)
                    } else {
                        ForEach(chatMessages, id: \.id) { message in
                            SingleMessageView(forMessage: message.content, sentAt: message.dateCreated, from: message.sender)
                                .id(message.id)
                        }
                        .onAppear {
                            scrollView.scrollTo(chatMessages.last?.id, anchor: .bottom)
                        }
                    }
                    if isLoadingResponse {
                        loadingView.id("loader")
                            .onAppear {
                                withAnimation { scrollView.scrollTo("loader", anchor: .center) }
                            }
                    }
                }
                .padding(.bottom, Constants.scrollViewBottomPadding)
                .onChange(of: chatMessages) { _ in
                    withAnimation { scrollView.scrollTo(chatMessages.last?.id, anchor: .center) }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    private var buttonPannelView: some View {
        HStack(spacing: 0) {
            TextField("Enter a message", text: $messageText)
                .padding(.bottom)
                .submitLabel(.send)
                .keyboardType(.asciiCapable)
            
            Button {
                if !messageText.isEmpty {
                    withAnimation {
                        isSendButtonTapped = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isSendButtonTapped = false
                        }
                    }
                    send(message: messageText)
                    self.hideKeyboard()
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
    
    private var loadingView: some View {
        HStack {
            ProgressView()
                .frame(width: 30, height: 30)
//                .padding()
            Text("AI is typing")
                .opacity(0.7)
                .font(.subheadline)
        }
    }
    
    private func send(message: String) {
        withAnimation { isLoadingResponse = true }
        let userMessage = ChatMessage(id: UUID().uuidString, content: message, dateCreated: Date(), sender: .user)
        chatMessages.append(userMessage)
        
        openAIService.send(message: messageText).sink { error in
            switch error {
            case .finished: break
            case .failure(_):
                withAnimation { showAlert = true }
                chatMessages.removeAll(where: { $0.content == userMessage.content })
            }
        } receiveValue: { response in
            guard let text = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            withAnimation { isLoadingResponse = false }
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
        self.send(message: text)
    }
}


