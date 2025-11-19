//
//  Order.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 17.11.2025.
//

import Foundation

struct Order: Codable {
    let id: String
    let nfts: [String]
}
