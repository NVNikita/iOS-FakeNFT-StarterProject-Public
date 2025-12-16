//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 18.11.2025.
//

import Foundation

protocol CartViewProtocol: AnyObject {
    func reloadTableView()
    func updateFooterInfo(count: String, price: String)
    func showLoading()
    func hideLoading()
    func showUIForEmptyState()
    func showUIForLoadedState()
    func showErrorAlert(message: String)
}

protocol CartPresenterProtocol: AnyObject {
    var nftItems: [NFTItem] { get }
    var currentSortType: String { get }
    
    func viewDidLoad()
    func didSelectSortType(_ type: String)
    func didTapDeleteNFT(at index: Int)
    func didTapPay()
}

final class CartPresenter: CartPresenterProtocol {
    
    weak var view: CartViewProtocol?
    
    private let cartService = CartService.shared
    private let nftService: NftService
    
    private(set) var nftItems: [NFTItem] = []
    private var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let sortTypeKey = "CartSortType"
    
    private(set) var currentSortType: String = "name"
    
    init(nftService: NftService) {
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        loadSortType()
        loadCartData()
    }
    
    func didSelectSortType(_ type: String) {
        currentSortType = type
        saveSortType()
        applyCurrentSort()
        view?.reloadTableView()
    }
    
    func didTapDeleteNFT(at index: Int) {
        guard index < nftItems.count else { return }
        
        let nftItem = nftItems[index]
        
        cartService.removeFromCart(nftId: nftItem.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.nftItems.remove(at: index)
                    self?.updateUI()
                    NotificationCenter.default.post(name: .cartDidUpdate, object: nil)
                case .failure(let error):
                    print("Error removing NFT: \(error)")
                    self?.view?.showErrorAlert(message: "Не удалось удалить NFT")
                }
            }
        }
    }
    
    func didTapPay() {
        
    }
    
    private func loadSortType() {
        if let savedSortType = userDefaults.string(forKey: sortTypeKey) {
            currentSortType = savedSortType
        } else {
            currentSortType = "name"
            saveSortType()
        }
    }
    
    private func saveSortType() {
        userDefaults.set(currentSortType, forKey: sortTypeKey)
    }
    
    private func applyCurrentSort() {
        switch currentSortType {
        case "price":
            sortByPrice()
        case "rating":
            sortByRating()
        case "name":
            sortByName()
        default:
            sortByName()
        }
    }
    
    private func sortByPrice() {
        nftItems.sort { $0.numericPrice > $1.numericPrice }
    }
    
    private func sortByRating() {
        nftItems.sort { $0.rating > $1.rating }
    }
    
    private func sortByName() {
        nftItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    private func loadCartData() {
        guard !isLoading else { return }
        
        isLoading = true
        view?.showLoading()
        
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
                self.view?.hideLoading()
                
                switch result {
                case .success(let nfts):
                    self.nftItems = self.cartService.convertToNFTItems(nfts)
                    self.applyCurrentSort()
                    self.updateUI()
                case .failure(let error):
                    print("Error loading NFTs: \(error)")
                    self.view?.showErrorAlert(message: "Не удалось загрузить NFT")
                    self.nftItems = []
                    self.updateUI()
                }
            }
        }
    }
    
    private func handleEmptyCart() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.view?.hideLoading()
            self.nftItems = []
            self.updateUI()
        }
    }
    
    private func handleLoadingError(_ error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.view?.hideLoading()
            print("Error loading cart: \(error)")
            self.view?.showErrorAlert(message: "Не удалось загрузить корзину")
            self.nftItems = self.cartService.getNFTs()
            self.applyCurrentSort()
            self.updateUI()
        }
    }
    
    private func updateUI() {
        if nftItems.isEmpty {
            view?.showUIForEmptyState()
        } else {
            view?.showUIForLoadedState()
            let countText = "\(nftItems.count) NFT"
            let priceText = cartService.getTotalPrice(nftItems: nftItems)
            view?.updateFooterInfo(count: countText, price: priceText)
            view?.reloadTableView()
        }
    }
}
