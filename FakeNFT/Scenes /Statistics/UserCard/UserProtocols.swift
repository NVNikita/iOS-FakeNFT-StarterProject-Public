import Foundation

protocol UserViewOutput: AnyObject {
    func viewDidLoad()
    func didTapWebsiteButton()
    func didSelectNFTCollection()
}

protocol UserViewInput: AnyObject {
    func showLoading()
    func hideLoading()
    func displayUser(name: String, bio: String, avatarURL: URL?, nftCount: Int, websiteVisible: Bool)
    func navigateToWeb(url: URL)
    func navigateToNFTCollection(nftIDs: [String])
}
