//
//  CurrencyServiceAssembly.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 12.11.2025.
//

import Foundation

final class CurrencyServiceProvider {
    static let shared = CurrencyServiceProvider()
    
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

