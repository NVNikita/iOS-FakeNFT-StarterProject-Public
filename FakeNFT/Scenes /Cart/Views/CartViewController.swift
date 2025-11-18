//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 26.10.2025.
//

import UIKit
import Kingfisher
import ProgressHUD

final class CartViewController: UIViewController {
    
    private enum SortType: String, CaseIterable {
        case price = "price"
        case rating = "rating"
        case name = "name"
    }
    
    private enum Constants {
        static let cornerRadius12: CGFloat = 12
        static let cornerRadius16: CGFloat = 16
        static let spacing: CGFloat = 16
        
        static let buttonTitle: String = "К оплате"
        static let placeHolderText: String = "Корзина пуста"
        
        static let numberOfLinesTitles: Int = 1
    }
    
    private let cartService = CartService.shared
    private let nftService: NftService
    private var nftItems: [NFTItem] = []
    private var cartUpdateObserver: NSObjectProtocol?
    private var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let sortTypeKey = "CartSortType"
    private var currentSortType: SortType = .name
    
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
    
    init(nftService: NftService) {
        self.nftService = nftService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSortType()
        setupUI()
        setupTableView()
        setupConstraints()
        setupCartObserver()
        hideAllUIElements()
        loadCartData()
    }
    
    private func hideAllUIElements() {
        nftTableView.isHidden = true
        footerStackView.isHidden = true
        placeholderTitle.isHidden = true
        navigationItem.rightBarButtonItem = nil
    }
    
    private func showUIElementsForLoadedState() {
        let isEmpty = nftItems.isEmpty
        
        if isEmpty {
            placeholderTitle.isHidden = false
            nftTableView.isHidden = true
            footerStackView.isHidden = true
            navigationItem.rightBarButtonItem = nil
        } else {
            placeholderTitle.isHidden = true
            nftTableView.isHidden = false
            footerStackView.isHidden = false
            setupNavigationBar()
        }
    }
    
    private func loadSortType() {
        if let savedSortType = userDefaults.string(forKey: sortTypeKey),
           let sortType = SortType(rawValue: savedSortType) {
            currentSortType = sortType
        } else {
            currentSortType = .name
            saveSortType()
        }
    }
    
    private func saveSortType() {
        userDefaults.set(currentSortType.rawValue, forKey: sortTypeKey)
    }
    
    private func applyCurrentSort() {
        switch currentSortType {
        case .price:
            sortByPrice()
        case .rating:
            sortByRating()
        case .name:
            sortByName()
        }
    }
    
    private func sortByPrice() {
        nftItems.sort { $0.numericPrice > $1.numericPrice }
        currentSortType = .price
        saveSortType()
        nftTableView.reloadData()
    }
    
    private func sortByRating() {
        nftItems.sort { $0.rating > $1.rating }
        currentSortType = .rating
        saveSortType()
        nftTableView.reloadData()
    }
    
    private func sortByName() {
        nftItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        currentSortType = .name
        saveSortType()
        nftTableView.reloadData()
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
            self?.loadCartData()
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
    
    func loadCartData() {
        guard !isLoading else { return }
        
        isLoading = true
        
        hideAllUIElements()
        ProgressHUD.show()
        
        cartService.getCart { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let order):
                if order.nfts.isEmpty {
                    self.handleEmptyCart()
                } else {
                    self.loadNFTItems(from: order.nfts)
                }
            case .failure(let error):
                self.handleLoadingError(error)
            }
        }
    }
    
    private func loadNFTItems(from nftIds: [String]) {
        cartService.loadNFTs(from: nftIds, nftService: nftService) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                ProgressHUD.dismiss()
                
                switch result {
                case .success(let nfts):
                    self.nftItems = self.cartService.convertToNFTItems(nfts)
                    self.applyCurrentSort()
                    self.updateUI()
                case .failure(let error):
                    print("Error loading NFTs: \(error)")
                    self.showErrorAlert(message: "Не удалось загрузить NFT")
                    self.nftItems = []
                    self.updateUI()
                }
            }
        }
    }
    
    private func handleEmptyCart() {
        DispatchQueue.main.async {
            self.isLoading = false
            ProgressHUD.dismiss()
            self.nftItems = []
            self.updateUI()
        }
    }
    
    private func handleLoadingError(_ error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            ProgressHUD.dismiss()
            print("Error loading cart: \(error)")
            self.showErrorAlert(message: "Не удалось загрузить корзину")
            self.nftItems = self.cartService.getNFTs()
            self.applyCurrentSort()
            self.updateUI()
        }
    }
    
    func updateUI() {
        nftCountLabel.text = "\(nftItems.count) NFT"
        priceNFTLabel.text = cartService.getTotalPrice(nftItems: nftItems)
        nftTableView.reloadData()
        showUIElementsForLoadedState()
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
        
        let priceButtonSort = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.sortByPrice()
        }
        
        let raitingButtonSort = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.sortByRating()
        }
        
        let nameButtonSort = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.sortByName()
        }
        
        let closeButton = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(priceButtonSort)
        alert.addAction(raitingButtonSort)
        alert.addAction(nameButtonSort)
        alert.addAction(closeButton)
        
        self.present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        
        if let imageURLString = nftItem.imageURL, let imageURL = URL(string: imageURLString) {
            cell.imageNFT.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            cell.imageNFT.image = nil
        }
        
        cell.config(
            image: cell.imageNFT.image,
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
        
        if let imageURLString = nftItem.imageURL, let imageURL = URL(string: imageURLString) {
            KingfisherManager.shared.retrieveImage(with: imageURL) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageResult):
                        alertVC.configure(imageView: imageResult.image)
                    case .failure:
                        alertVC.configure(imageView: nil)
                    }
                }
            }
        } else {
            alertVC.configure(imageView: nil)
        }
        
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
        
        cartService.removeFromCart(nftId: nftItem.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.nftItems.remove(at: indexPath.row)
                    self?.updateUI()
                case .failure(let error):
                    print("Error removing NFT: \(error)")
                    self?.showErrorAlert(message: "Не удалось удалить NFT")
                }
            }
        }
    }
}
