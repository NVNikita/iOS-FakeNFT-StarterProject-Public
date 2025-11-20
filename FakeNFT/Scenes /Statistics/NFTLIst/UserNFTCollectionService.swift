import Foundation

final class UserNFTCollectionService: UserNFTCollectionServiceProtocol {
    
    private let nftService: NftService
    
    init(nftService: NftService = NftServiceImpl(
        networkClient: DefaultNetworkClient(),
        storage: NftStorageImpl()
    )) {
        self.nftService = nftService
    }
    
    func fetchUserNFTs(nftIDs: [String], completion: @escaping (Result<[Nft], UserNFTCollectionError>) -> Void) {
        guard !nftIDs.isEmpty else {
            completion(.success([]))
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var nfts: [Nft] = []
        var errors: [Error] = []
        
        for nftID in nftIDs {
            dispatchGroup.enter()
            
            nftService.loadNft(id: nftID) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    errors.append(error)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if nfts.isEmpty, let firstError = errors.first {
                completion(.failure(.generalError(firstError)))
            } else {
                completion(.success(nfts))
            }
        }
    }
}
