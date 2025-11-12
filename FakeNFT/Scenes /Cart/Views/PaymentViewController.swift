//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 31.10.2025.
//

import UIKit
import Kingfisher
import ProgressHUD

final class PaymentViewController: UIViewController {
    
    private var currencies: [Currency] = []
    private let currencyService: CurrencyServiceProtocol
    
    
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.whiteYP
        return collectionView
    }()
    
    init(currencyService: CurrencyServiceProtocol = CurrencyServiceAssembly.shared.currencyService) {
        self.currencyService = currencyService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupNavigationBar()
        setupConstaints()
        setupAgreementText()
        loadCurrencies()
    }
    
    private func setupNavigationBar() {
        title = "Выберите способ оплаты"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.whiteYP
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.blackYP,
            .font: UIFont.bold17SFPro
        ]
        
        appearance.shadowColor = .clear
        
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
        view.addSubview(collectionView)
        
        footerStackView.addArrangedSubview(agreementTextView)
        footerStackView.addArrangedSubview(payButton)
        
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
        agreementTextView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CurrencyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            payButton.leadingAnchor.constraint(equalTo: footerStackView.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: footerStackView.trailingAnchor, constant: -20),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footerStackView.topAnchor)
        ])
    }
    
    private func loadCurrencies() {
        ProgressHUD.show()
        currencyService.loadCurrencies { [weak self] result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success(let currencies):
                    self?.currencies = currencies
                    self?.collectionView.reloadData()
                case .failure(let error):
                    return
                }
            }
        }
    }
    
    @objc private func payButtonTap() {
        
    }
}

extension PaymentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL, in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        let webViewController = WebViewController(url: URL)
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        
        return false
    }
}

extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CurrencyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let currency = currencies[indexPath.item]
        
        if let imageUrl = URL(string: currency.image) {
            cell.config(title: currency.title, name: currency.name, imageUrl: imageUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCurrency = currencies[indexPath.item]
        print("Selected currency: \(selectedCurrency.title)")
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16 - 16 - 7) / 2
        return CGSize(width: width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}
