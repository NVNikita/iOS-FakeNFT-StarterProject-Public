//
//  ClearOrderRequest.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 17.11.2025.
//

import Foundation

struct ClearOrderRequest: NetworkRequest {
    var dto: (any Dto)?
    
    let orderId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
    
    var httpMethod: HttpMethod { .post }
}
