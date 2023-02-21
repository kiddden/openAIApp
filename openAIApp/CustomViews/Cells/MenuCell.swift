//
//  MenuCell.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

import UIKit

class MenuCell: UITableViewCell {
    
    let symbolContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSizeZero
        return view
    }()
    
    let sfSymbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)

        label.textColor = UIColor(named: Colors.menuLabelColor)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        addSubviews(symbolContainerView, stackView)
        symbolContainerView.addSubview(sfSymbolView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            symbolContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            symbolContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            symbolContainerView.widthAnchor.constraint(equalToConstant: 64),
            symbolContainerView.heightAnchor.constraint(equalToConstant: 64),
            
            sfSymbolView.centerXAnchor.constraint(equalTo: symbolContainerView.centerXAnchor),
            sfSymbolView.centerYAnchor.constraint(equalTo: symbolContainerView.centerYAnchor),
            sfSymbolView.widthAnchor.constraint(equalToConstant: 30),
            sfSymbolView.heightAnchor.constraint(equalToConstant: 30),
            
            stackView.leadingAnchor.constraint(equalTo: symbolContainerView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            stackView.centerYAnchor.constraint(equalTo: symbolContainerView.centerYAnchor)
        ])
    }
    
    func configure(forIndex index: IndexPath) {
        if index.row == 0 {
            sfSymbolView.image = UIImage(systemName: SFSymbols.messages)
            titleLabel.text = MenuItems.chatGPT
            descriptionLabel.text = MenuItems.chatGPTDescription
            symbolContainerView.backgroundColor = UIColor(named: Colors.ourPurple)
        } else {
            sfSymbolView.image = UIImage(systemName: SFSymbols.image)
            titleLabel.text = MenuItems.imageGeneration
            descriptionLabel.text = MenuItems.imageGenerationDescription
            symbolContainerView.backgroundColor = UIColor(named: Colors.ourGreen)
        }
    }
}
