//
//  ChatVC.swift
//  openAIApp
//
//  Created by Eugene Ned on 09.02.2023.
//

import UIKit
import SwiftUI

class ChatVC: UIViewController {
    
    private var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congifureVC()
        setupObserversForKeyboard()
    }
    
    private func congifureVC() {
        // Congifuring NavigationBar
        title = "Chat"
        navigationController?.navigationBar.tintColor = .systemPurple
        
        // Fixing bug with transparent nav bar when keyboard is up
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        
        // Configuring SwiftUI View
        let messagesView = UIHostingController(rootView: ChatMessagesView())
        addChild(messagesView)
        view.addSubview(messagesView.view)
        messagesView.view.frame = view.bounds
        messagesView.didMove(toParent: self)
    }
    
    private func setupObserversForKeyboard() {
        // Registering observers for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        // Getting the height of the keyboard
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
        }
        
        // Moving view up when keyboard appears
        UIView.animate(withDuration: 0.3) { self.view.frame.origin.y = -self.keyboardHeight+10 }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Discarding the previus view position when keyboard dissapears
        UIView.animate(withDuration: 0.3) { self.view.frame.origin.y = 0 }
    }
}
