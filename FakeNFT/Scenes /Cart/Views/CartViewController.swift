//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 26.10.2025.
//

import UIKit

final class CartViewController: UIViewController {
    
    private let cartService = CartService.shared
    
    private var nftItems: [NFTItem] {
        return cartService.getNFTs()
    }
    
    private var cartUpdateObserver: NSObjectProtocol?
    
    private enum Constants {
        static let cornerRadius12: CGFloat = 12
        static let cornerRadius16: CGFloat = 16
        static let spacing: CGFloat = 16
        
        static let buttonTitle: String = "К оплате"
        static let placeHolderText: String = "Корзина пуста"
        
        static let numberOfLinesTitles: Int = 1
    }
    
    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.spacing
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = Constants.cornerRadius12
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stackView.backgroundColor = UIColor.yaLightGrayLight
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular15SFPro
        label.textColor = UIColor.blackYP
        label.numberOfLines = Constants.numberOfLinesTitles
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceNFTLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.greenYP
        label.font = UIFont.bold17SFPro
        label.numberOfLines = Constants.numberOfLinesTitles
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.bold17SFPro
        button.backgroundColor = UIColor.blackYP
        button.titleLabel?.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius16
        button.addTarget(self, action: #selector(payButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var placeholderTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.placeHolderText
        label.font = UIFont.bold17SFPro
        label.textColor = UIColor.blackYP
        label.numberOfLines = Constants.numberOfLinesTitles
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupTableView()
        setupConstraints()
        setupCartObserver()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func setupNavigationBar() {
        let sortButton = UIBarButtonItem(
            image: UIImage(named: "sorted_button"),
            style: .plain,
            target: self,
            action: #selector(sortedButtonTap)
        )
        sortButton.tintColor = UIColor.blackYP
        
        navigationItem.rightBarButtonItem = sortButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = UIColor.whiteYP
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.whiteYP
        
        view.addSubview(nftTableView)
        view.addSubview(footerStackView)
        footerStackView.addSubview(nftCountLabel)
        footerStackView.addSubview(priceNFTLabel)
        footerStackView.addSubview(payButton)
        view.addSubview(placeholderTitle)
    }
    
    private func setupTableView() {
        nftTableView.delegate = self
        nftTableView.dataSource = self
        nftTableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupCartObserver() {
        cartUpdateObserver = NotificationCenter.default.addObserver(
            forName: .cartDidUpdate,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateUI()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: footerStackView.topAnchor),
            
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
        
        if isEmpty {
            navigationItem.rightBarButtonItem = nil
        } else {
            setupNavigationBar()
        }
    }
    
    private func updateUI() {
        nftCountLabel.text = "\(nftItems.count) NFT"
        priceNFTLabel.text = cartService.getTotalPrice()
        
        checkPlaceholder()
        nftTableView.reloadData()
    }
    
    @objc private func payButtonTap() {
        let payVC = PaymentViewController()
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.blackYP
        
        payVC.navigationItem.leftBarButtonItem = backButton
        
        let navVC = UINavigationController(rootViewController: payVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func sortedButtonTap() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet)
        
        let priceButtonSort = UIAlertAction(title: "По цене", style: .default) { _ in
            print("priceButtonSort tap")
        }
        
        let raitingButtonSort = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            print("raitingButtonSort tap")
        }
        
        let nameButtonSort = UIAlertAction(title: "По названию", style: .default) { _ in
            print("nameButtonSort tap")
        }
        
        let closeButton = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(priceButtonSort)
        alert.addAction(raitingButtonSort)
        alert.addAction(nameButtonSort)
        alert.addAction(closeButton)
        
        self.present(alert, animated: true)
    }
    
    deinit {
        if let observer = cartUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                as? NFTTableViewCell else {
            return UITableViewCell()
        }
        
        let nftItem = nftItems[indexPath.row]
        
        cell.config(
            image: nftItem.image,
            nameNFT: nftItem.name,
            rating: nftItem.rating,
            priceNFT: nftItem.price
        )
        
        cell.backgroundColor = UIColor.white
        cell.onDeleteButtonTapped = { [weak self] in
            self?.showDeleteAlert(for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController {
    private func showDeleteAlert(for indexPath: IndexPath) {
        let alertVC = CustomAlertViewController()
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        
        let nftItem = nftItems[indexPath.row]
        alertVC.configure(imageView: nftItem.image)
        
        alertVC.onBackButtonTapped = {
            print("Вернуться tapped - отмена удаления")
        }
        
        alertVC.onDeleteButtonTapped = { [weak self] in
            print("Удалить tapped для indexPath: \(indexPath)")
            self?.performDelete(at: indexPath)
        }
        
        present(alertVC, animated: true)
    }
    
    private func performDelete(at indexPath: IndexPath) {
        let nftItem = nftItems[indexPath.row]
        cartService.removeNFT(withId: nftItem.id)
    }
}
