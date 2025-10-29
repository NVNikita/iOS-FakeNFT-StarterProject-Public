//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Sergey on 24.10.2025.

import Foundation

struct Profile: Codable {
    var name: String?
    var avatar: String?
    var description: String?
    var website: String?
    var nfts: [String]
    var likes: [String]
    var id: String
}
