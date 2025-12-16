//
//  CurrencyStorage.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 12.11.2025.
//

import Foundation

protocol CurrencyStorageProtocol {
    func saveCurrencies(_ currencies: Currencies)
    func getCurrencies() -> Currencies?
}

final class CurrencyStorage: CurrencyStorageProtocol {
    private let storage = UserDefaults.standard
    private let currenciesKey = "currencies"
    
    func saveCurrencies(_ currencies: Currencies) {
        if let encoded = try? JSONEncoder().encode(currencies) {
            storage.set(encoded, forKey: currenciesKey)
        }
    }
    
    func getCurrencies() -> Currencies? {
        guard let data = storage.data(forKey: currenciesKey),
              let currencies = try? JSONDecoder().decode(Currencies.self, from: data) else {
            return nil
        }
        return currencies
    }
}
