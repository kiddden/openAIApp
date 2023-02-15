//
//  ChatVC.swift
//  openAIApp
//
//  Created by Eugene Ned on 09.02.2023.
//

import UIKit
import SwiftUI

class ChatVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        congifureVC()
    }
    
    private func congifureVC() {
        // Congifuring NavigationBar
        title = "Chat"
        
        // Configuring SwiftUI View
        let messagesView = UIHostingController(rootView: ChatMessagesView())
        addChild(messagesView)
        view.addSubview(messagesView.view)
        messagesView.view.frame = view.bounds
        messagesView.didMove(toParent: self)
    }
}
