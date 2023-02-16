//
//  Constants.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

enum SFSymbols {
    // For chat
    static let send = "arrow.up.circle.fill"
    
    // For menu
    static let image = "photo"
    static let messages = "text.bubble.fill"

    // For empty state view in chat
    static let examplesImage = "sun.max"
    static let capabilitiesImage = "bolt"
    static let limitationsImage = "exclamationmark.triangle"
}

enum MenuItems {
    static let chatGPT = "Chat GPT"
    static let chatGPTDescription = "Live communication with AI"
    static let imageGeneration = "Image generation"
    static let imageGenerationDescription = "Generate and edit images"
}

enum EmptyStateOptions {
    static let examples = "Examples"
    static let capabilities = "Capabilities"
    static let limitations = "Limitations"
    
    static let examplesOptions = [
        "Explain quantum computing in simple terms",
        "Got any creative ideas for an iOS app?",
        "How do I make an HTTP request in Swift?",
    ]
    static let capabilitiesOptions = [
        "Remembers what user said earlier in the conversation",
        "Allows user to provide follow-up corrections",
        "Trained to decline inappropriate requests",
    ]
    static let limitationsOptions = [
        "May occasionally generate incorrect information",
        "May occasionally produce harmful instructions biased content",
        "Limited knowledge of world and events after 2021",
    ]
}
