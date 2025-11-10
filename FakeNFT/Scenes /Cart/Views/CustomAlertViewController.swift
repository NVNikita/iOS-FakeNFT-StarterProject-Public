//
//  CustomAlertView.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 09.11.2025.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    private lazy var blurBackground: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = UIColor.whiteYP.withAlphaComponent(0.1)
        blurView.alpha = 0.8
        return blurView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var imageNFTView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular13SFPro
        label.text = "Вы уверены, что хотите \nудалить объект из корзины?"
        label.textAlignment = .center
        label.textColor = UIColor.blackYP
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(UIColor.whiteYP, for: .normal)
        button.titleLabel?.font = UIFont.bold17SFPro
        button.backgroundColor = UIColor.blackYP
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(UIColor.redYP, for: .normal)
        button.titleLabel?.font = UIFont.bold17SFPro
        button.backgroundColor = UIColor.blackYP
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onBackButtonTapped: (() -> Void)?
    var onDeleteButtonTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    private func setupUI() {
        view.addSubview(blurBackground)
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(buttonStackView)
        
        stackView.addArrangedSubview(imageNFTView)
        stackView.addArrangedSubview(messageLabel)
        
        buttonStackView.addArrangedSubview(deleteButton)
        buttonStackView.addArrangedSubview(backButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        imageNFTView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            blurBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurBackground.topAnchor.constraint(equalTo: view.topAnchor),
            blurBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20),
            
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            
            imageNFTView.heightAnchor.constraint(equalToConstant: 80),
            imageNFTView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    func configure(imageView: UIImage?) {
        self.imageNFTView.image = imageView
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true) {
            self.onBackButtonTapped?()
        }
    }
    
    @objc private func deleteButtonTapped() {
        dismiss(animated: true) {
            self.onDeleteButtonTapped?()
        }
    }
    
    @objc private func backgroundTapped() {
        dismiss(animated: true) {
            self.onBackButtonTapped?()
        }
    }
}
