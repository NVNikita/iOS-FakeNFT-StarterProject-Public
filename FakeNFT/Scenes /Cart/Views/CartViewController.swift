//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 26.10.2025.
//

import UIKit

final class CartViewController: UIViewController {
    
    private var nftItems: [String] = []
    
    private lazy var nftTableView = UITableView()
    
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
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.text = "3 NFT"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var priceNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "3,54 ETH"
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("К оплате", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.titleLabel?.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTap), for: .allEditingEvents)
        return button
    }()
    
    private lazy var placeholderTitle: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupConstarints()
        checkPlaceholder()
    }
    
    private func setupNavigationBar() {
        //TODO: - to do nav bar
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.background
        
        view.addSubview(nftTableView)
        view.addSubview(footerStackView)
        footerStackView.addSubview(nftCountLabel)
        footerStackView.addSubview(priceNFTLabel)
        footerStackView.addSubview(payButton)
        view.addSubview(placeholderTitle)
        
        nftTableView.translatesAutoresizingMaskIntoConstraints = false
        nftTableView.backgroundColor = .clear
        
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        nftCountLabel.translatesAutoresizingMaskIntoConstraints = false
        priceNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
        placeholderTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        nftTableView.delegate = self
        nftTableView.dataSource = self
        nftTableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "cell")
        nftTableView.separatorStyle = .none
        nftTableView.allowsSelection = false
    }
    
    private func setupConstarints() {
        NSLayoutConstraint.activate([
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: footerStackView.topAnchor),
            nftTableView.heightAnchor.constraint(equalToConstant: CGFloat(140 * 3)),
            
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerStackView.heightAnchor.constraint(equalToConstant: 76),
            
            payButton.trailingAnchor.constraint(equalTo: footerStackView.trailingAnchor, constant: -16),
            payButton.topAnchor.constraint(equalTo: footerStackView.topAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: footerStackView.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: footerStackView.leadingAnchor, constant: 119),
            
            nftCountLabel.topAnchor.constraint(equalTo: payButton.topAnchor),
            nftCountLabel.leadingAnchor.constraint(equalTo: footerStackView.leadingAnchor, constant: 16),
            
            priceNFTLabel.bottomAnchor.constraint(equalTo: payButton.bottomAnchor),
            priceNFTLabel.leadingAnchor.constraint(equalTo: nftCountLabel.leadingAnchor),
            
            placeholderTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func checkPlaceholder() {
        let isEmpty = nftItems.isEmpty
        
        placeholderTitle.isHidden = !isEmpty
        nftTableView.isHidden = isEmpty
        footerStackView.isHidden = isEmpty
    }
    
    @objc private func payButtonTap() {
        
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                as? NFTTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .white
        return cell
    }
}
