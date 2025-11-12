//
//  PaymentRequest.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 13.11.2025.
//

import UIKit

struct PaymentRequest: NetworkRequest {
    var dto: (any Dto)?
    
    let currencyId: String
    let orderId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)/payment/\(currencyId)")
    }
    
    var httpMethod: HttpMethod { .get }
}
