//
//  PaymentResult.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 13.11.2025.
//

import Foundation

struct PaymentResult: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
