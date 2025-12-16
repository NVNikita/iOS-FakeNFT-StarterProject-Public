import Foundation

struct UserNFTCellModel {
    let id: String
    let imageURL: URL?
    let title: String
    let priceETH: Double?
    let rating: Int?
    let onCartTap: (() -> Void)?

    init(nft: Nft, onCartTap: (() -> Void)?) {
        self.id = nft.id
        self.imageURL = nft.images.first
        
        self.title = nft.name ?? "Без названия"
        
        self.priceETH = nft.price
        
        self.rating = nft.rating
        
        self.onCartTap = onCartTap
    }

    var priceString: String? {
        guard let priceETH = priceETH else { return nil }
        return String(format: "%.2f ETH", priceETH)
    }
}
