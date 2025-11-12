//
//  CurrencyServiceAssembly.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 12.11.2025.
//

import Foundation

final class CurrencyServiceAssembly {
    static let shared = CurrencyServiceAssembly()
    
    private let networkClient: NetworkClient
    private let storage: CurrencyStorageProtocol
    
    init(
        networkClient: NetworkClient = DefaultNetworkClient(),
        storage: CurrencyStorageProtocol = CurrencyStorage()
    ) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    var currencyService: CurrencyServiceProtocol {
        CurrencyService(networkClient: networkClient, storage: storage)
    }
}

