//
//  Currency.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 12.11.2025.
//

import Foundation

struct Currency: Codable {
    let id: String
    let title: String
    let name: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, name, image
    }
}

typealias Currencies = [Currency]
