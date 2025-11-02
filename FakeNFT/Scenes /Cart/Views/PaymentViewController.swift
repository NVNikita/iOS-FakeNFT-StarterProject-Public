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
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 12
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stackView.backgroundColor = UIColor.yaLightGrayLight
        return stackView
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupConstaints()
    }
    
    private func setupNavigationBar() {
        title = "Выберите способ оплаты"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(footerStackView)
        footerStackView.addSubview(payButton)
        
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCollectionView() {
        
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerStackView.heightAnchor.constraint(equalToConstant: 186),
            
            payButton.leadingAnchor.constraint(equalTo: footerStackView.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: footerStackView.trailingAnchor, constant: -12),
            payButton.topAnchor.constraint(equalTo: footerStackView.topAnchor, constant: 76),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func payButtonTap() {
        
    }
}
