import Foundation

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    
    weak var view: UserNFTCollectionViewInput?
    private var items: [UserNFTCellModel] = []
    
    private let service: UserNFTCollectionServiceProtocol
    private let nftIDs: [String]

    init(service: UserNFTCollectionServiceProtocol, nftIDs: [String]) {
        self.service = service
        self.nftIDs = nftIDs
    }
    
    var nftsCount: Int {
        return items.count
    }
    
    func nft(at index: Int) -> UserNFTCellModel {
        return items[index]
    }
    
    func viewDidLoad() {
        loadNFTs()
    }
    
    private func loadNFTs() {
        guard !nftIDs.isEmpty else {
            items = []
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
                    self.items = nfts.map(UserNFTCellModel.init)
                    let isEmpty = self.items.isEmpty
                    self.view?.showEmptyState(isVisible: isEmpty)
                    self.view?.displayNFTs()
                case .failure(let error):
                    self.items = []
                    self.view?.showEmptyState(isVisible: true)
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
