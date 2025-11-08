//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 31.10.2025.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 12
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stackView.backgroundColor = UIColor.lightGreyYP
        return stackView
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.bold17SFPro
        button.backgroundColor = UIColor.blackYP
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var agreementTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = UIFont.regular13SFPro
        textView.textColor = UIColor.blackYP
        textView.delegate = self
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupConstaints()
        setupAgreementText()
    }
    
    private func setupNavigationBar() {
        title = "Выберите способ оплаты"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.blackYP,
            .font: UIFont.bold17SFPro
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupAgreementText() {
        let agreementText = "Совершая покупку, вы соглашаетесь с условиями Политики конфиденциальности"
        
        let attributedString = NSMutableAttributedString(string: agreementText)
        
        if let range = agreementText.range(of: "Политики конфиденциальности") {
            let nsRange = NSRange(range, in: agreementText)
            
            attributedString.addAttribute(.link,
                                          value: "https://yandex.ru/legal/practicum_termsofuse/ru/",
                                          range: nsRange)
            
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.blackYP,
                                          range: NSRange(location: 0, length: agreementText.count))
            
            attributedString.addAttribute(.font,
                                          value: UIFont.regular13SFPro,
                                          range: NSRange(location: 0, length: agreementText.count))
        }
        
        agreementTextView.attributedText = attributedString
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.whiteYP
        
        view.addSubview(footerStackView)
        
        footerStackView.addArrangedSubview(agreementTextView)
        footerStackView.addArrangedSubview(payButton)
        
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
        agreementTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCollectionView() {
        
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            payButton.leadingAnchor.constraint(equalTo: footerStackView.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: footerStackView.trailingAnchor, constant: -20),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func payButtonTap() {
        
    }
}

extension PaymentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        let webViewController = WebViewController(url: URL)
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        
        return false
    }
}
