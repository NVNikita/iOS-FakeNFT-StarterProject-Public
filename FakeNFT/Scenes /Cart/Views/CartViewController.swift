//
//  CartViewController.swift
//  FakeNFT
//

import UIKit
import Kingfisher
import ProgressHUD

final class CartViewController: UIViewController {
    
    private enum Constants {
        static let cornerRadius12: CGFloat = 12
        static let cornerRadius16: CGFloat = 16
        static let spacing: CGFloat = 16
        
        static let buttonTitle: String = "К оплате"
        static let placeHolderText: String = "Корзина пуста"
        
        static let numberOfLinesTitles: Int = 1
    }
    
    private let presenter: CartPresenterProtocol
    private var nftItems: [NFTItem] { presenter.nftItems }
    private var cartUpdateObserver: NSObjectProtocol?
    
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
    
    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupConstraints()
        setupCartObserver()
        hideAllUIElements()
        presenter.viewDidLoad()
    }
    
    private func hideAllUIElements() {
        nftTableView.isHidden = true
        footerStackView.isHidden = true
        placeholderTitle.isHidden = true
        navigationItem.rightBarButtonItem = nil
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
            self?.presenter.viewDidLoad()
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
    
    @objc private func payButtonTap() {
        let paymentPresenter = PaymentPresenter()
        let payVC = PaymentViewController(presenter: paymentPresenter)
        paymentPresenter.view = payVC
        
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
            self?.presenter.didSelectSortType("price")
        }
        
        let raitingButtonSort = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.presenter.didSelectSortType("rating")
        }
        
        let nameButtonSort = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.presenter.didSelectSortType("name")
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

extension CartViewController: CartViewProtocol {
    func reloadTableView() {
        nftTableView.reloadData()
    }
    
    func updateFooterInfo(count: String, price: String) {
        nftCountLabel.text = count
        priceNFTLabel.text = price
    }
    
    func showLoading() {
        ProgressHUD.show()
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
    
    func showUIForEmptyState() {
        placeholderTitle.isHidden = false
        nftTableView.isHidden = true
        footerStackView.isHidden = true
        navigationItem.rightBarButtonItem = nil
    }
    
    func showUIForLoadedState() {
        placeholderTitle.isHidden = true
        nftTableView.isHidden = false
        footerStackView.isHidden = false
        setupNavigationBar()
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            self?.presenter.didTapDeleteNFT(at: indexPath.row)
        }
        
        present(alertVC, animated: true)
    }
}
