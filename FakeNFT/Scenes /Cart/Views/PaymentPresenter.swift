//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 18.11.2025.
//

import Foundation

protocol PaymentViewProtocol: AnyObject {
    func reloadCollectionView()
    func updatePayButtonState(isEnabled: Bool)
    func showLoading()
    func hideLoading()
    func showLoadError(message: String, retryAction: @escaping () -> Void)
    func showPaymentError(message: String, retryAction: @escaping () -> Void)
    func showSuccessPayment()
}

protocol PaymentPresenterProtocol: AnyObject {
    var currencies: [Currency] { get }
    var selectedCurrencyIndex: Int? { get set }
    
    func viewDidLoad()
    func didSelectCurrency(at index: Int)
    func payButtonTapped()
    func retryLoadCurrencies()
}

final class PaymentPresenter: PaymentPresenterProtocol {
    
    weak var view: PaymentViewProtocol?
    
    private let currencyService: CurrencyServiceProtocol
    private let orderId: String?
    
    private(set) var currencies: [Currency] = []
    var selectedCurrencyIndex: Int?
    
    init(orderId: String? = nil,
         currencyService: CurrencyServiceProtocol = CurrencyServiceProvider.shared.currencyService) {
        self.orderId = orderId
        self.currencyService = currencyService
    }
    
    func viewDidLoad() {
        loadCurrencies()
    }
    
    func didSelectCurrency(at index: Int) {
        selectedCurrencyIndex = index
        view?.updatePayButtonState(isEnabled: true)
    }
    
    func payButtonTapped() {
        guard let selectedIndex = selectedCurrencyIndex else { return }
        
        let selectedCurrency = currencies[selectedIndex]
        let currentOrderId = orderId ?? "1"
        
        view?.showLoading()
        
        currencyService.payOrder(with: selectedCurrency.id, orderId: currentOrderId) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let paymentResult):
                    if paymentResult.success {
                        self?.view?.showSuccessPayment()
                    } else {
                        self?.view?.showPaymentError(message: "Не удалось произвести оплату") {
                            self?.payButtonTapped()
                        }
                    }
                case .failure(let error):
                    print("[PaymentPresenter] - [func payment] - [Error: \(error)]")
                    self?.view?.showPaymentError(message: "Ошибка оплаты") {
                        self?.payButtonTapped()
                    }
                }
            }
        }
    }
    
    func retryLoadCurrencies() {
        loadCurrencies()
    }
    
    private func loadCurrencies() {
        view?.showLoading()
        
        currencyService.loadCurrencies { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let currencies):
                    self?.currencies = currencies
                    self?.view?.reloadCollectionView()
                case .failure(let error):
                    self?.view?.showLoadError(message: "Не удалось загрузить валюты") {
                        self?.loadCurrencies()
                    }
                    print("[PaymentPresenter] - [func loadCurrencies] - [Error: \(error)]")
                }
            }
        }
    }
}
