import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let name: String?
    let rating: Int?
    let price: Double?
    let author: String?
    
    enum CodingKeys: String, CodingKey {
        case id, images, name, rating, price, author
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        images = try container.decode([URL].self, forKey: .images)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        author = try container.decodeIfPresent(String.self, forKey: .author)
    }
    
    // Для обратной совместимости
    init(id: String, images: [URL]) {
        self.id = id
        self.images = images
        self.name = nil
        self.rating = nil
        self.price = nil
        self.author = nil
    }
}
