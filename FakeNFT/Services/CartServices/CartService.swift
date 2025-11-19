//
//  CartService.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 14.11.2025.
//

import Foundation

typealias CartCompletion = (Result<Order, Error>) -> Void
typealias NFTsCompletion = (Result<[Nft], Error>) -> Void

final class CartService {
    
    static let shared = CartService()
    private init() {}
    
    private let networkClient: NetworkClient = DefaultNetworkClient()
    private let orderId = "1"
    
    func getCart(completion: @escaping CartCompletion) {
        let request = GetOrderRequest(orderId: orderId)
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateCart(nftIds: [String], completion: @escaping CartCompletion) {
        let request = UpdateOrderRequest(orderId: orderId, nfts: nftIds)
        networkClient.send(request: request, type: Order.self) { [weak self] result in
            switch result {
            case .success(let order):
                self?.postCartUpdateNotification()
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeFromCart(nftId: String, completion: @escaping CartCompletion) {
        getCart { [weak self] result in
            switch result {
            case .success(let currentOrder):
                let updatedNFTs = currentOrder.nfts.filter { $0 != nftId }
                self?.updateCart(nftIds: updatedNFTs, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func clearCart(completion: @escaping CartCompletion) {
        updateCart(nftIds: [], completion: completion)
    }
    
    func loadNFTs(from nftIds: [String], nftService: NftService, completion: @escaping NFTsCompletion) {
        guard !nftIds.isEmpty else {
            completion(.success([]))
            return
        }
        
        var loadedNFTs: [Nft] = []
        var errors: [Error] = []
        let group = DispatchGroup()
        
        for nftId in nftIds {
            group.enter()
            
            nftService.loadNft(id: nftId) { result in
                switch result {
                case .success(let nft):
                    loadedNFTs.append(nft)
                case .failure(let error):
                    errors.append(error)
                    print("Error loading NFT \(nftId): \(error)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if loadedNFTs.isEmpty && !errors.isEmpty {
                completion(.failure(errors.first!))
            } else {
                completion(.success(loadedNFTs))
            }
        }
    }
    
    func getNFTs() -> [NFTItem] {
        return []
    }
    
    func removeNFT(withId id: String) {
        removeFromCart(nftId: id) { _ in }
    }
    
    func addNFT(_ nft: NFTItem) {
        getCart { [weak self] result in
            switch result {
            case .success(let currentOrder):
                var updatedNFTs = currentOrder.nfts
                if !updatedNFTs.contains(nft.id) {
                    updatedNFTs.append(nft.id)
                    self?.updateCart(nftIds: updatedNFTs, completion: { _ in })
                }
            case .failure(let error):
                print("Error adding NFT: \(error)")
            }
        }
    }
    
    func clearCart() {
        clearCart { _ in }
    }
    
    func getTotalPrice() -> String {
        return "0,00 ETH"
    }
    
    func getTotalPrice(nfts: [Nft]) -> String {
        let totalPrice = nfts.reduce(0.0) { $0 + $1.price }
        return String(format: "%.2f ETH", totalPrice).replacingOccurrences(of: ".", with: ",")
    }
    
    func getTotalPrice(nftItems: [NFTItem]) -> String {
        let totalPrice = nftItems.reduce(0.0) { $0 + $1.numericPrice }
        return String(format: "%.2f ETH", totalPrice).replacingOccurrences(of: ".", with: ",")
    }
    
    func getTotalItemsCount() -> Int {
        return 0
    }
    
    func isNFTInCart(_ id: String) -> Bool {
        return false
    }
    
    func convertToNFTItem(_ nft: Nft) -> NFTItem {
        return NFTItem(
            id: nft.id,
            name: nft.name,
            price: String(format: "%.2f ETH", nft.price),
            rating: nft.rating,
            imageURL: nft.images.first?.absoluteString
        )
    }
    
    func convertToNFTItems(_ nfts: [Nft]) -> [NFTItem] {
        return nfts.map { convertToNFTItem($0) }
    }
    
    private func postCartUpdateNotification() {
        NotificationCenter.default.post(name: .cartDidUpdate, object: nil)
    }
}

extension Notification.Name {
    static let cartDidUpdate = Notification.Name("cartDidUpdate")
}
