//
//  CurrencyRequest.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 12.11.2025.
//

import Foundation

struct CurrencyRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var endpoint: URL? {
        URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/currencies")
    }
    
    var httpMethod: HttpMethod { .get }
}
