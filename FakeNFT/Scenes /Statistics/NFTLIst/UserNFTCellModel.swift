import Foundation

struct UserNFTCellModel {
    let id: String
    let imageURL: URL?
    let title: String
    let priceETH: Double?
    let rating: Int?

    init(nft: Nft) {
        self.id = nft.id
        self.imageURL = nft.images.first
        self.title = "NFT #\(nft.id.prefix(4))"
        
        self.priceETH = Double.random(in: 0.1...5.0)
        self.rating = Int.random(in: 1...5)
    }

    var priceString: String? {
        guard let priceETH = priceETH else { return nil }
        return String(format: "%.2f ETH", priceETH)
    }
}
