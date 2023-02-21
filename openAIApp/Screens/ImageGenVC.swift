////
////  ImageGenerationVC.swift
////  openAIApp
////
////  Created by Eugene Ned on 09.02.2023.
////

import UIKit
import Combine

class ImageGenerationVC: UIViewController {
    
    private var keyboardHeight: CGFloat = 0
    private let placholder = "Enter your image prompt"
    
    private let imageContainer = IGContainerView()
    private let textFieldContainer = IGContainerView()
    
    private let padding: CGFloat = 8
    
    private let progressBar: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let scrollStackContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .redraw
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = .tertiarySystemBackground
        return view
    }()
    
    private let multilineTextField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .lightGray
        view.isScrollEnabled = false
        view.layer.cornerRadius = 16
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.backgroundColor = .tertiarySystemBackground
        return view
    }()
    
    private let generateButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: Colors.ourGreen)
        view.layer.cornerRadius = 16
        view.setTitle("Generate", for: .normal)
        view.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        view.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private let textFieldLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Image prompt"
        view.font = UIFont.preferredFont(forTextStyle: .body)
        return view
    }()
    
    private let errorAlert: UIAlertController = {
        let view = UIAlertController(title: "Something went wrong",
                                     message: "We couldn't generate an image for you, please try again",
                                     preferredStyle: .alert)
        view.addAction(UIAlertAction(title: "Understood", style: .default, handler: nil))
        return view
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()
        congifureVC()
        setupObserversForKeyboard()
        layoutScrollView()
        layoutScrollStackContainer()
        layoutImageViewSection()
        layoutTextFieldSection()
        
    }
    
    private func congifureVC() {
        // Congifuring NavigationBar
        title = "Image Generation"
        navigationController?.navigationBar.tintColor = .systemGreen
        view.backgroundColor = .systemBackground
        
        // Fixing bug with transparent nav bar when keyboard is up
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func layoutScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func layoutScrollStackContainer() {
        scrollView.addSubview(scrollStackContainer)
        scrollStackContainer.addArrangedSubview(imageContainer)
        scrollStackContainer.addArrangedSubview(textFieldContainer)
        
        NSLayoutConstraint.activate([
            scrollStackContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding),
            scrollStackContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -200),
            scrollStackContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func layoutImageViewSection() {
        imageContainer.addSubview(imageView)
        imageView.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            imageContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -padding),
            
            progressBar.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            progressBar.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 50),
            progressBar.widthAnchor.constraint(equalTo: progressBar.heightAnchor)
        ])
    }
    
    private func layoutTextFieldSection() {
        multilineTextField.delegate = self
        multilineTextField.text = placholder
        textFieldContainer.addSubviews(multilineTextField, generateButton, textFieldLabel)
        
        NSLayoutConstraint.activate([
            textFieldContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            textFieldContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            textFieldContainer.heightAnchor.constraint(equalToConstant: 200),
            
            generateButton.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: padding),
            generateButton.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -padding),
            generateButton.heightAnchor.constraint(equalToConstant: 40),
            generateButton.widthAnchor.constraint(equalToConstant: 110),
            
            multilineTextField.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: padding),
            multilineTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: padding),
            multilineTextField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -padding),
            multilineTextField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: -padding),
            
            textFieldLabel.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: padding),
            textFieldLabel.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 2*padding),
            textFieldLabel.trailingAnchor.constraint(equalTo: generateButton.leadingAnchor, constant: -padding),
            textFieldLabel.bottomAnchor.constraint(equalTo: multilineTextField.topAnchor, constant: -padding),
        ])
        
    }
    
    @objc private func generateButtonTapped() {
        DispatchQueue.main.async {
            self.imageView.layer.opacity = 0.5
            self.progressBar.startAnimating()
        }
        OpenAIService.shared.generateImage(forPrompt: multilineTextField.text)
            .flatMap { response -> AnyPublisher<UIImage?, Error> in
                guard let imageURL = URL(string: response.data.first!.url) else {
                    return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)).eraseToAnyPublisher()
                }
                return OpenAIService.shared.downloadImage(from: imageURL)
            }
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print("Error downloading image: \(error)")
                    DispatchQueue.main.async {
                        self.present(self.errorAlert, animated: true, completion: nil)
                        self.progressBar.stopAnimating()
                        self.imageView.layer.opacity = 1
                    }
                case .finished:
                    DispatchQueue.main.async {
                        self.progressBar.stopAnimating()
                        self.imageView.layer.opacity = 1
                    }
                }
            }, receiveValue: { [weak self] image in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            })
            .store(in: &cancellables)
    }
}

extension ImageGenerationVC {
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
        UIView.animate(withDuration: 0.3) { self.scrollStackContainer.frame.origin.y = -self.keyboardHeight+200 }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        // Discarding the previus view position when keyboard dissapears
        UIView.animate(withDuration: 0.3) { self.scrollStackContainer.frame.origin.y = 0 }
    }
}

extension ImageGenerationVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if multilineTextField.text == placholder {
            multilineTextField.text = ""
            multilineTextField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if multilineTextField.text == "" {
            multilineTextField.text = placholder
            multilineTextField.textColor = .lightGray
        }
    }
}
