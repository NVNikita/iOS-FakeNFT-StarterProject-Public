import Foundation

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    
    weak var view: UserNFTCollectionViewInput?
    private var nfts: [Nft] = []
    
    private let service: UserNFTCollectionServiceProtocol
    private let nftIDs: [String]

    init(service: UserNFTCollectionServiceProtocol, nftIDs: [String]) {
        self.service = service
        self.nftIDs = nftIDs
    }
    
    var nftsCount: Int {
        return nfts.count
    }
    
    func nft(at index: Int) -> UserNFTCellModel {
        let nft = nfts[index]
        
        let onCartTap = { [weak self] in
            guard let self = self else { return }
        }
        
        return UserNFTCellModel(nft: nft, onCartTap: onCartTap)
    }
    
    func viewDidLoad() {
        loadNFTs()
    }
    
    private func loadNFTs() {
        guard !nftIDs.isEmpty else {
            nfts = []
            view?.showEmptyState(isVisible: true)
            view?.displayNFTs()
            return
        }
        
        view?.showLoading()
        
        service.fetchUserNFTs(nftIDs: nftIDs) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view?.hideLoading()
                
                switch result {
                case .success(let nfts):
                    self.nfts = nfts
                    let isEmpty = self.nfts.isEmpty
                    self.view?.showEmptyState(isVisible: isEmpty)
                    self.view?.displayNFTs()
                case .failure(let error):
                    self.nfts = []
                    self.view?.showEmptyState(isVisible: true)
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
