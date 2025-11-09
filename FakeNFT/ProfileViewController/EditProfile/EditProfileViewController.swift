import UIKit
import Kingfisher


final class EditProfileViewController: UIViewController, EditProfileViewInput {
    
    // MARK: - Properties
    private let presenter: EditProfileViewOutput
    private lazy var editProfileView = EditProfileView()
    
    private var saveBarButtonItem: UIBarButtonItem?
    
    // MARK: - Init
    init(presenter: EditProfileViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        wireActions()
        presenter.viewDidLoad()
    }
    
    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        // Не показываем заголовок
        navigationItem.title = nil
        navigationController?.navigationBar.tintColor = UIColor(named: "YBlackColor")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        // Перенос строки после слова «Уверены»
        let alertTitle = "Уверены,\nчто хотите выйти?"
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Остаться", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Wiring
    private func wireActions() {
        editProfileView.avatarTapped = { [weak self] in
            self?.presenter.didTapChangeAvatar()
        }
        
        editProfileView.onSaveTapped = { [weak self] in
            guard let self else { return }
            self.presenter.didTapClose(
                name: self.editProfileView.nameTextView.text,
                description: self.editProfileView.infoTextView.text,
                website: self.editProfileView.siteTextView.text
            )
        }
        
        editProfileView.nameChanged = { [weak self] text in
            self?.presenter.didChangeName(text)
        }
        editProfileView.infoChanged = { [weak self] text in
            self?.presenter.didChangeDescription(text)
        }
        editProfileView.siteChanged = { [weak self] text in
            self?.presenter.didChangeWebsite(text)
        }
    }
    
    // MARK: - EditProfileViewInput
    func display(profile: EditProfileViewData) {
        editProfileView.nameTextView.text = profile.name
        editProfileView.infoTextView.text = profile.description
        editProfileView.siteTextView.text = profile.website
        if let url = profile.avatarURL {
            editProfileView.profileAvatar.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
        } else {
            editProfileView.profileAvatar.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    func setAvatar(url: URL?) {
        if let url {
            editProfileView.profileAvatar.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
        }
    }
    
    func setLoading(_ isLoading: Bool) {

        view.isUserInteractionEnabled = !isLoading
        editProfileView.setSaveButtonEnabled(!isLoading)
        
        if isLoading {
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.startAnimating()
            indicator.center = view.center
            indicator.tag = 9999
            view.addSubview(indicator)
        } else {
            view.viewWithTag(9999)?.removeFromSuperview()
        }
    }
    
    func showValidationError(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error.title", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setChangePhotoButtonVisible(_ visible: Bool) {
        editProfileView.setChangePhotoButtonVisible(visible)
    }
}
