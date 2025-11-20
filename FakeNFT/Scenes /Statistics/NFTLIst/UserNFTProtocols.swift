import Foundation

// MARK: - Service
enum UserNFTCollectionError: Error {
    case generalError(Error)
    case missingData
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .generalError(let error):
            return error.localizedDescription
        case .missingData:
            return "Не удалось получить данные NFT. Данные отсутствуют."
        case .invalidResponse:
            return "Получен неверный ответ от сервера."
        }
    }
}

protocol UserNFTCollectionServiceProtocol: AnyObject {
    func fetchUserNFTs(nftIDs: [String], completion: @escaping (Result<[Nft], UserNFTCollectionError>) -> Void)
}

// MARK: - MVP Protocols
protocol UserNFTCollectionViewInput: AnyObject {
    func showLoading()
    func hideLoading()
    func displayNFTs()
    func showEmptyState(isVisible: Bool)
    func showError(message: String)
}

protocol UserNFTCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    var nftsCount: Int { get }
    func nft(at index: Int) -> UserNFTCellModel
}

typealias UserNFTCollectionViewOutput = UserNFTCollectionPresenterProtocol
