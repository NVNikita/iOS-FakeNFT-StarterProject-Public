
import Foundation

// MARK: - View Input/Output

protocol EditProfileViewInput: AnyObject {
    func display(profile: EditProfileViewData)
    func setAvatar(url: URL?)
    func setLoading(_ isLoading: Bool)
    func showValidationError(message: String)
    func setChangePhotoButtonVisible(_ visible: Bool)
}

protocol EditProfileViewOutput: AnyObject {
    func viewDidLoad()
    func didTapClose(name: String?, description: String?, website: String?)
    func didTapChangeAvatar()
    func didChangeName(_ text: String)
    func didChangeDescription(_ text: String)
    func didChangeWebsite(_ text: String)
}

// MARK: - Interactor

protocol EditProfileInteractorInput: AnyObject {
    func loadCurrentProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    func updateProfile(_ profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void)
    func validateAvatarURL(_ string: String) -> URL?
}

protocol EditProfileInteractorOutput: AnyObject {}

// MARK: - Router

protocol EditProfileRouterInput: AnyObject {
    func dismiss()
    func presentAvatarURLPrompt(completion: @escaping (String?) -> Void)
}

// MARK: - ViewModel

struct EditProfileViewData {
    let name: String
    let description: String
    let website: String
    let avatarURL: URL?
}

// MARK: - Presenter

final class EditProfilePresenterImpl: EditProfileViewOutput {

    weak var view: EditProfileViewInput?
    weak var outputDelegate: EditProfileDelegate?

    private let interactor: EditProfileInteractorInput
    private let router: EditProfileRouterInput

    // Текущее состояние редактируемого профиля
    private var profile: Profile
    // Черновые значения полей
    private var draftName: String?
    private var draftDescription: String?
    private var draftWebsite: String?
    private var draftAvatarURL: String?

    init(interactor: EditProfileInteractorInput,
         router: EditProfileRouterInput,
         initialProfile: Profile) {
        self.interactor = interactor
        self.router = router
        self.profile = initialProfile
    }

    // MARK: - EditProfileViewOutput

    func viewDidLoad() {
        let viewData = makeViewData(from: profile)
        view?.display(profile: viewData)
    }

    func didTapClose(name: String?, description: String?, website: String?) {
        draftName = name
        draftDescription = description
        draftWebsite = website

        // Сформировать итоговый профиль
        var updated = profile
        updated.name = draftName
        updated.description = draftDescription
        updated.website = draftWebsite
        if let avatar = draftAvatarURL {
            updated.avatar = avatar
        }

        view?.setLoading(true)

        // Не перетираем лайки: просим interactor загрузить актуальный профиль,
        // переносим likes из него, а затем отправляем update
        interactor.loadCurrentProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let currentServerProfile):
                var final = updated
                final.likes = currentServerProfile.likes
                final.nfts = currentServerProfile.nfts
                self.interactor.updateProfile(final) { [weak self] updateResult in
                    guard let self else { return }
                    self.view?.setLoading(false)
                    switch updateResult {
                    case .success(let savedProfile):
                        self.outputDelegate?.didUpdateProfile(savedProfile)
                        self.router.dismiss()
                    case .failure(let error):
                        let message = Self.humanReadable(error: error)
                        self.view?.showValidationError(message: message)
                    }
                }
            case .failure(let error):
                self.view?.setLoading(false)
                let message = Self.humanReadable(error: error)
                self.view?.showValidationError(message: message)
            }
        }
    }

    func didTapChangeAvatar() {
        router.presentAvatarURLPrompt { [weak self] text in
            guard let self else { return }
            guard let text, let url = self.interactor.validateAvatarURL(text) else {
                // Пустое нажатие «Отмена» игнорируем, а неверный URL покажем ошибку
                if let text, !text.isEmpty {
                    self.view?.showValidationError(message: NSLocalizedString("InvalidURL", comment: ""))
                }
                return
            }
            self.draftAvatarURL = url.absoluteString
            self.view?.setAvatar(url: url)
        }
    }

    func didChangeName(_ text: String) {
        draftName = text
    }

    func didChangeDescription(_ text: String) {
        draftDescription = text
    }

    func didChangeWebsite(_ text: String) {
        draftWebsite = text
    }

    // MARK: - Helpers

    private func makeViewData(from profile: Profile) -> EditProfileViewData {
        let name = profile.name ?? ""
        let description = profile.description ?? ""
        let website = profile.website ?? ""
        let avatarURL = URL(string: profile.avatar ?? "")
        return EditProfileViewData(name: name, description: description, website: website, avatarURL: avatarURL)
    }

    private static func humanReadable(error: Error) -> String {
        switch error {
        case is NetworkClientError:
            return NSLocalizedString("Error.network", comment: "")
        default:
            return NSLocalizedString("Error.unknown", comment: "")
        }
    }
}
