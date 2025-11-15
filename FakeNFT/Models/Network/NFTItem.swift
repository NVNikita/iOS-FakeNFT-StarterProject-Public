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
    let imageURL: String? // Храним URL или имя картинки вместо UIImage
    
    // Вычисляемое свойство для цены как числа
    var numericPrice: Double {
        let numericString = price
            .replacingOccurrences(of: "ETH", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        return Double(numericString) ?? 0.0
    }
    
    // Опциональное свойство для UIImage (не кодируется)
    var image: UIImage? {
        // Здесь логика загрузки картинки по imageURL
        // Например, из кэша или Assets
        return UIImage(named: imageURL ?? "")
    }
}
