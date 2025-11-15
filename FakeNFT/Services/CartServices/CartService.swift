//
//  CartService.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 14.11.2025.
//

import Foundation

final class CartService {
    
    static let shared = CartService()
    private init() {}
    
    private let cartKey = "nftShoppingCart"
    
    func addNFT(_ nft: NFTItem) {
        var currentNFTs = getNFTs()
        
        guard !currentNFTs.contains(where: { $0.id == nft.id }) else { return }
        
        currentNFTs.append(nft)
        saveNFTs(currentNFTs)
        postCartUpdateNotification()
    }
    
    func removeNFT(withId id: String) {
        var currentNFTs = getNFTs()
        currentNFTs.removeAll { $0.id == id }
        saveNFTs(currentNFTs)
        postCartUpdateNotification()
    }
    
    func getNFTs() -> [NFTItem] {
        guard let data = UserDefaults.standard.data(forKey: cartKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([NFTItem].self, from: data)
        } catch {
            print("Error decoding NFT items: \(error)")
            return []
        }
    }
    
    func clearCart() {
        UserDefaults.standard.removeObject(forKey: cartKey)
        postCartUpdateNotification()
    }
    
    func getTotalPrice() -> String {
        let items = getNFTs()
        let totalPrice = items.reduce(0.0) { $0 + $1.numericPrice }
        return String(format: "%.2f ETH", totalPrice).replacingOccurrences(of: ".", with: ",")
    }
    
    func getTotalItemsCount() -> Int {
        return getNFTs().count
    }
    
    func isNFTInCart(_ id: String) -> Bool {
        return getNFTs().contains(where: { $0.id == id })
    }
    
    private func saveNFTs(_ items: [NFTItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: cartKey)
        } catch {
            print("Error encoding NFT items: \(error)")
        }
    }
    
    private func postCartUpdateNotification() {
        NotificationCenter.default.post(name: .cartDidUpdate, object: nil)
    }
}

extension Notification.Name {
    static let cartDidUpdate = Notification.Name("cartDidUpdate")
}
