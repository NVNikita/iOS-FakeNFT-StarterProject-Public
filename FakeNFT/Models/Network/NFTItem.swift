//
//  NFTItem.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 12.11.2025.
//

import UIKit

struct NFTItem: Codable {
    let id: String
    let name: String
    let price: String
    let rating: Int
    let imageURL: String?
    
    var numericPrice: Double {
        let numericString = price
            .replacingOccurrences(of: "ETH", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        return Double(numericString) ?? 0.0
    }
    
    var image: UIImage? {
        return UIImage(named: imageURL ?? "")
    }
}
