//
//  ChatEmptyStateView.swift
//  openAIApp
//
//  Created by Eugene Ned on 16.02.2023.
//

import SwiftUI

struct ChatEmptyStateView: View {
    
    var delegate: EmptyStatePointViewDelegate
    
    var body: some View {
        VStack {
            examplesView
            capabilitiesView
            limitationsView
        }
    }
    
    private func configureViewWith(text: String, image: String) -> some View {
        return VStack {
            Image(systemName: image)
                .resizable()
                .frame(width: 24, height: 24)
            Text(text)
                .font(.body)
        }
    }
    
    private var examplesView: some View {
        VStack {
            configureViewWith(text: EmptyStateOptions.examples, image: SFSymbols.examplesImage)
            ForEach(EmptyStateOptions.examplesOptions, id: \.self) { text in
                EmptyStatePointView(text: text, delegate: delegate)
            }
        }
    }
    
    private var capabilitiesView: some View {
        VStack {
            configureViewWith(text: EmptyStateOptions.capabilities, image: SFSymbols.capabilitiesImage)
            ForEach(EmptyStateOptions.capabilitiesOptions, id: \.self) { text in
                EmptyStatePointView(text: text)
            }
        }
    }
    
    private var limitationsView: some View {
        VStack {
            configureViewWith(text: EmptyStateOptions.limitations, image: SFSymbols.limitationsImage)
            ForEach(EmptyStateOptions.limitationsOptions, id: \.self) { text in
                EmptyStatePointView(text: text)
            }
        }
    }
}

