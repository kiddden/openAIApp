//
//  View+Ext.swift
//  openAIApp
//
//  Created by Eugene Ned on 17.02.2023.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
