import Foundation
import UIKit

// MARK: - View Input/Output

protocol ProfileViewInput: AnyObject {
    func display(profile: Profile)
    func setLoading(_ isLoading: Bool)
    func showError(message: String, retry: (() -> Void)?)
    func updateLikesCount()
}

protocol ProfileViewOutput: AnyObject {
    func viewDidLoad()
    func didTapEdit()
    func didTapWebsite(_ address: String)
    func didTapMyNFT()
    func didTapFavorites()
}

// MARK: - Interactor

protocol ProfileInteractorInput: AnyObject {
    func loadProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    func loadNFTs(ids: [String], completion: @escaping (Result<[MyNFT], Error>) -> Void)
    func updateLikes(_ likes: [String], completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - Router

protocol ProfileRouterInput: AnyObject {
    func openEditProfile(with profile: Profile, delegate: EditProfileDelegate?)
    func openWeb(url: URL)
    func pushMyNFT(nfts: [MyNFT], onSaveLikes: @escaping () -> Void)
    func pushFavorites(nfts: [MyNFT], onSaveLikes: @escaping () -> Void)
}

// MARK: - Presenter

final class ProfilePresenterImpl: ProfileViewOutput {
    
    private weak var view: ProfileViewInput?
    private let interactor: ProfileInteractorInput
    private let router: ProfileRouterInput
    private let likesStorage = LikesStorageImpl.shared
    
    private var currentProfile: Profile?
    private var myNftIds: [String] = []
    private var likedIds: [String] = []
    
    init(view: ProfileViewInput,
         interactor: ProfileInteractorInput,
         router: ProfileRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - ProfileViewOutput
    
    func viewDidLoad() {
        view?.setLoading(true)
        interactor.loadProfile { [weak self] result in
            guard let self else { return }
            self.view?.setLoading(false)
            switch result {
            case .success(let profile):
                self.currentProfile = profile
                self.myNftIds = profile.nfts
                self.likesStorage.syncLikes(with: profile.likes)
                self.likedIds = self.likesStorage.getAllLikes()
                self.view?.display(profile: profile)
            case .failure:
                self.view?.showError(message: NSLocalizedString("FailedToLoadProfile", comment: ""), retry: { [weak self] in
                    self?.viewDidLoad()
                })
            }
        }
    }
    
    func didTapEdit() {
        guard let profile = currentProfile else { return }
        router.openEditProfile(with: profile, delegate: self)
    }
    
    func didTapWebsite(_ address: String) {
        let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let normalized = (trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://")) ? trimmed : "https://\(trimmed)"
        guard let url = URL(string: normalized) else { return }
        router.openWeb(url: url)
    }
    
    func didTapMyNFT() {
        loadNFTsAndNavigate(ids: myNftIds, toFavorites: false)
    }
    
    func didTapFavorites() {
        likedIds = likesStorage.getAllLikes()
        loadNFTsAndNavigate(ids: likedIds, toFavorites: true)
    }
    
    // MARK: - Helpers
    
    private func loadNFTsAndNavigate(ids: [String], toFavorites: Bool) {
        interactor.loadNFTs(ids: ids) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nfts):
                let onSaveLikes: () -> Void = { [weak self] in
                    guard let self else { return }
                    self.view?.updateLikesCount()
                    let likes = self.likesStorage.getAllLikes()
                    self.interactor.updateLikes(likes) { _ in
                    }
                }
                if toFavorites {
                    self.router.pushFavorites(nfts: nfts, onSaveLikes: onSaveLikes)
                } else {
                    self.router.pushMyNFT(nfts: nfts, onSaveLikes: onSaveLikes)
                }
            case .failure:
                self.view?.showError(message: NSLocalizedString("Error.unknown", comment: ""), retry: nil)
            }
        }
    }
}

// MARK: - EditProfileDelegate

extension ProfilePresenterImpl: EditProfileDelegate {
    func didUpdateProfile(_ profile: Profile) {
        currentProfile = profile
        view?.display(profile: profile)
    }
}
