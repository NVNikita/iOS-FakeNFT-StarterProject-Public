import UIKit
import WebKit
import ProgressHUD

final class ProfileViewController: UIViewController {

    // MARK: - Dependencies

    private let servicesAssembly: ServicesAssembly

    // MARK: - Views

    private let profileView = ProfileView()
    private var profile: Profile?

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

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    // MARK: - Init

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view = profileView
        setupEditButton()
        loadProfile()

        profileView.websiteLabelTapped = { [weak self] address in
            self?.didTapOnWebsiteLabel(with: address)
        }
        profileView.aboutDeveloper = { [weak self] address in
            self?.didTapOnWebsiteLabel(with: address)
        }
    }

    // MARK: - Setup

    private func setupEditButton() {
        view.addSubview(editButton)
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    // MARK: - Private

    private func loadProfile() {
        ProgressHUD.show()
        servicesAssembly.profileService.loadProfile { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                ProgressHUD.dismiss()
                switch result {
                case .success(let loadedProfile):
                    self.profile = loadedProfile
                    self.profileView.updateUI(with: loadedProfile)
                case .failure(let error):
                    self.showErrorAlert(with: error)
                }
            }
        }
    }

    private func showErrorAlert(with error: Error) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error.title", comment: ""),
            message: NSLocalizedString("FailedToLoadProfile", comment: ""),
            preferredStyle: .alert
        )
        let retryAction = UIAlertAction(
            title: NSLocalizedString("TryAgain", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.loadProfile()
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .cancel,
            handler: nil
        )
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func editProfileTapped() {
       guard let profile = profile else { return }
       let assembly = EditProfileAssembly(servicesAssembly: servicesAssembly, delegate: self)
       let editVC = assembly.build(with: profile)
       editVC.modalPresentationStyle = .formSheet
       present(editVC, animated: true, completion: nil)
   }
    
    private func didTapOnWebsiteLabel(with urlString: String) {
        var validURLString = urlString
        if !urlString.hasPrefix("https://") {
            validURLString = "https://\(urlString)"
        }
        guard let url = URL(string: validURLString) else { return }

        let request = URLRequest(url: url)
        webView.load(request)

        let webViewController = UIViewController()
        webViewController.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: webViewController.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewController.view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: webViewController.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewController.view.trailingAnchor)
        ])
        webViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

// MARK: - EditProfileDelegate

 extension ProfileViewController: EditProfileDelegate {
     func didUpdateProfile(_ profile: Profile) {
        self.profile = profile
        profileView.updateUI(with: profile)
        let name = profile.name ?? ""
        let description = profile.description ?? ""
         let website = profile.website ?? ""
         let avatar = profile.avatar ?? ""
        servicesAssembly.profileService.updateProfile(
            name: name,
            description: description,
            website: website,
             avatar: avatar
         ) { result in
             switch result {
            case .success(let updatedProfile):
                print("Profile successfully updated: \(updatedProfile)")
            case .failure(let error):
                print("Error updating profile: \(error)")
             }
         }
     }
 }


