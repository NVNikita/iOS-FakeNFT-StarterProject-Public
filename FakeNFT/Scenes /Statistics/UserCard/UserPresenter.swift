import Foundation

final class UserPresenter {
    weak var view: UserViewInput?
    private let user: User

    init(user: User) {
        self.user = user
    }
}

extension UserPresenter: UserViewOutput {
    func viewDidLoad() {
        view?.showLoading()
        
        let avatarURL: URL?
        if let avatarString = user.avatar, let url = URL(string: avatarString) {
            avatarURL = url
        } else {
            avatarURL = nil
        }
        
        let websiteVisible = user.website != nil && URL(string: user.website ?? "") != nil

        view?.displayUser(
            name: user.name,
            bio: user.description ?? "Биография не указана",
            avatarURL: avatarURL,
            nftCount: user.nftCount,
            websiteVisible: websiteVisible
        )
        
        view?.hideLoading()
    }
    
    func didTapWebsiteButton() {
        guard let websiteString = user.website, let url = URL(string: websiteString) else {
            return
        }
        view?.navigateToWeb(url: url)
    }
    
    func didSelectNFTCollection() {
        guard user.nftCount > 0 else { return }
        view?.navigateToNFTCollection(nftIDs: user.nfts)
    }
}
