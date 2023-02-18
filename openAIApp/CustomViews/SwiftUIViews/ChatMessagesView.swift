//
//  ChatMessagesView.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

import SwiftUI
import Combine

struct ChatMessagesView: View {
    @StateObject private var viewModel = ChatMessagesViewModel()
    
    @State private var isSendButtonTapped = false
    
    var body: some View {
        VStack(spacing: 0) {
            messagesView
                .overlay(buttonPannelView, alignment: .bottom)
        }
        .alert(isPresented: $viewModel.showAlert) { errorAlert }
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                VStack(spacing: 0) {
                    if viewModel.chatMessages.isEmpty {
                        ChatEmptyStateView(delegate: viewModel)
                            .padding(.horizontal, 4)
                    } else {
                        ForEach(viewModel.chatMessages, id: \.id) { message in
                            SingleMessageView(forMessage: message.content, sentAt: message.dateCreated, from: message.sender)
                                .id(message.id)
                        }
                        .onAppear {
                            scrollView.scrollTo(viewModel.chatMessages.last?.id, anchor: .bottom)
                        }
                    }
                    
                    if viewModel.isLoadingResponse {
                        loadingView.id("loader")
                            .onAppear {
                                withAnimation { scrollView.scrollTo("loader", anchor: .center) }
                            }
                    }
                }
                .padding(.top)
                .padding(.bottom, Constants.scrollViewBottomPadding)
                .onChange(of: viewModel.chatMessages) { _ in
                    withAnimation { scrollView.scrollTo(viewModel.chatMessages.last?.id, anchor: .center) }
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
            TextField("Enter a message", text: $viewModel.messageText)
                .padding(.bottom)
                .submitLabel(.send)
                .keyboardType(.asciiCapable)
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    viewModel.send(message: viewModel.messageText)
                }
            
            Button {
                if !viewModel.messageText.isEmpty {
                    withAnimation {
                        isSendButtonTapped = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isSendButtonTapped = false
                        }
                    }
                    viewModel.send(message: viewModel.messageText)
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
    
    private var errorAlert: Alert {
        Alert(title: Text("Something went wrong"),
              message: Text("Please try again"),
              dismissButton: .default(Text("Got it!"), action: {
            withAnimation { viewModel.isLoadingResponse = false }
        }))
    }
    
    private var loadingView: some View {
        HStack {
            ProgressView()
                .frame(width: 30, height: 30)
            Text("AI is typing")
                .opacity(0.7)
                .font(.subheadline)
        }
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


