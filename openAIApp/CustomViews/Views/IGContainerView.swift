//
//  IGContainerView.swift
//  openAIApp
//
//  Created by Eugene Ned on 21.02.2023.
//

import UIKit

class IGContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 22
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
    }
}
