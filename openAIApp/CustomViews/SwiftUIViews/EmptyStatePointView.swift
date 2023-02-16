//
//  EmptyStatePointView.swift
//  openAIApp
//
//  Created by Eugene Ned on 16.02.2023.
//

import SwiftUI

protocol EmptyStatePointViewDelegate {
    func didTapOnExample(text: String)
}

struct EmptyStatePointView: View {
    let text: String
    var isTappable: Bool = false
    var delegate: EmptyStatePointViewDelegate? = nil
    
    var body: some View {
        VStack {
            if isTappable, let delegate = delegate {
                Button {
                    delegate.didTapOnExample(text: text)
                } label: {
                    Text("\""+text+"\"") + Text(Image(systemName: "arrow.right"))
                }
            } else {
                Text(text)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 70)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .multilineTextAlignment(.center)
    }
}

extension EmptyStatePointView {
    init(text: String, isTappable: Bool, delegate: EmptyStatePointViewDelegate) {
        self.text = text
        self.isTappable = isTappable
        self.delegate = delegate
    }
}
