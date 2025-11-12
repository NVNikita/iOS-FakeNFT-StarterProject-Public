//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 12.11.2025.
//

import Foundation

protocol CurrencyServiceProtocol {
    func loadCurrencies(completion: @escaping (Result<Currencies, Error>) -> Void)
}

final class CurrencyService: CurrencyServiceProtocol {
    
    private let networkClient: NetworkClient
    private let storage: CurrencyStorageProtocol
    
    init(networkClient: NetworkClient, storage: CurrencyStorageProtocol) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    func loadCurrencies(completion: @escaping (Result<Currencies, Error>) -> Void) {
        let request = CurrencyRequest()
        
        networkClient.send(request: request, type: Currencies.self) { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.storage.saveCurrencies(currencies)
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
