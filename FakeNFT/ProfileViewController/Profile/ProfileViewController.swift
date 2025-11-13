import UIKit
import WebKit
import Kingfisher
import ProgressHUD


enum NFTScreenType {
    case nftScreen
    case favoritesScreen
}

final class ProfileViewController: UIViewController, ProfileViewInput {
    
    // MARK: - Dependencies
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - MVP
    private var presenter: ProfileViewOutput!
    private var interactor: ProfileInteractorInput!
    private var router: ProfileRouterImpl!
    
    // MARK: - Views
    private let profileView = ProfileView()
    
    // MARK: - UI Elements
    private lazy var editButton: UIButton = {
        let button = UIButton()
        let imageButton = UIImage(named: "Edit")
        button.setImage(imageButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    // MARK: - Localization Keys
    private enum L {
        static let errorTitle = NSLocalizedString("Error.title", comment: "")
        static let failedToLoadProfile = NSLocalizedString("FailedToLoadProfile", comment: "")
        static let tryAgain = NSLocalizedString("TryAgain", comment: "")
        static let cancel = NSLocalizedString("Cancel", comment: "")
    }
    
    // MARK: - Initialization
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
        assembleMVP()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Assembly
    private func assembleMVP() {
        interactor = ProfileInteractorImpl(servicesAssembly: servicesAssembly)
        router = ProfileRouterImpl()
        router.viewController = self
        presenter = ProfilePresenterImpl(view: self, interactor: interactor, router: router)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        setupEditButton()
        wireViewCallbacks()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup Methods
    private func setupEditButton() {
        view.addSubview(editButton)
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func wireViewCallbacks() {
        profileView.myNFTTapped = { [weak self] in
            self?.presenter.didTapMyNFT()
        }
        profileView.favoritesTapped = { [weak self] in
            self?.presenter.didTapFavorites()
        }
        profileView.websiteLabelTapped = { [weak self] address in
            self?.presenter.didTapWebsite(address)
        }
        profileView.aboutDeveloper = { [weak self] address in
            self?.presenter.didTapWebsite(address)
        }
    }
    
    // MARK: - Actions
    @objc private func editProfileTapped() {
        presenter.didTapEdit()
    }
    
    // MARK: - ProfileViewInput
    func display(profile: Profile) {
        profileView.updateUI(with: profile)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            ProgressHUD.show()
        } else {
            ProgressHUD.dismiss()
        }
    }
    
    func showError(message: String, retry: (() -> Void)?) {
        presentErrorAlert(
            title: L.errorTitle,
            message: message,
            retry: retry
        )
    }
    
    func updateLikesCount() {
        profileView.updateLikesCountAndUI()
    }
}

// MARK: - Alerts
private extension ProfileViewController {
    func presentErrorAlert(title: String, message: String, retry: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        if let retry = retry {
            alert.addAction(UIAlertAction(
                title: L.tryAgain,
                style: .default,
                handler: { _ in retry() }
            ))
        }
        alert.addAction(UIAlertAction(
            title: L.cancel,
            style: .cancel,
            handler: nil
        ))
        present(alert, animated: true, completion: nil)
    }
}
