//
//  SuccessfulPaymentView.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 13.11.2025.
//

import UIKit

final class SuccessfulPaymentViewController: UIViewController {
    
    private enum Constants {
        static let cornerRadius16: CGFloat = 16
        static let messageTitle: String = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        static let buttonText: String = "Вернуться в корзину"
        static let numberOfLines: Int = 0
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "successful_payment_png")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.messageTitle
        label.font = UIFont.bold22SFPro
        label.textColor = UIColor.blackYP
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.buttonText, for: .normal)
        button.setTitleColor(UIColor.whiteYP, for: .normal)
        button.titleLabel?.font = UIFont.bold17SFPro
        button.backgroundColor = UIColor.blackYP
        button.layer.cornerRadius = Constants.cornerRadius16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cartButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var presenter: SuccessfulPaymentPresenter = {
        let presenter = SuccessfulPaymentPresenter()
        presenter.view = self
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activateConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.whiteYP
        
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        view.addSubview(cartButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 49),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            imageView.heightAnchor.constraint(equalToConstant: 248),
            
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            messageLabel.heightAnchor.constraint(equalToConstant: 56),
            
            cartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            cartButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func cartButtonTap() {
        presenter.cartButtonTapped()
    }
}
