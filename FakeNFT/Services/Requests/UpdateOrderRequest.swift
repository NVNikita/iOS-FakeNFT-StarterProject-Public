//
//  UpdateOrderRequest.swift
//  FakeNFT
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    var dto: (any Dto)?
    
    let orderId: String
    let nfts: [String]
    
    init(orderId: String, nfts: [String]) {
        self.orderId = orderId
        self.nfts = nfts
        self.dto = UpdateOrderDTO(nfts: nfts) as? any Dto
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
    
    var httpMethod: HttpMethod { .put }
}

struct UpdateOrderDTO: Encodable {
    let nfts: [String]
}
