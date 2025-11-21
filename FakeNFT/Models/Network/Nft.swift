import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    
    let name: String
    let rating: Int
    let price: Double
    let author: String?
    
    private static let defaultName = ""
    private static let defaultRating = 0
    private static let defaultPrice = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id, images, name, rating, price, author
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        images = try container.decode([URL].self, forKey: .images)
        
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? Nft.defaultName
        rating = try container.decodeIfPresent(Int.self, forKey: .rating) ?? Nft.defaultRating
        price = try container.decodeIfPresent(Double.self, forKey: .price) ?? Nft.defaultPrice
        
        author = try container.decodeIfPresent(String.self, forKey: .author)
    }
    
    init(id: String, images: [URL]) {
        self.id = id
        self.images = images
        self.name = Nft.defaultName
        self.rating = Nft.defaultRating
        self.price = Nft.defaultPrice
        self.author = nil
    }
}
