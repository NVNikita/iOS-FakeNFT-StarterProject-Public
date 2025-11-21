import UIKit
import Kingfisher

final class EditProfileView: UIView {
    
    // MARK: - Callbacks (события для VC/Presenter)
    var closeTapped: (() -> Void)?
    var avatarTapped: (() -> Void)?
    var nameChanged: ((String) -> Void)?
    var infoChanged: ((String) -> Void)?
    var siteChanged: ((String) -> Void)?
    var onSaveTapped: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(resource: .yBlack)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    lazy var profileAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.Layout.profileAvatarCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Кнопка поверх аватара — теперь с иконкой камеры
    private lazy var profileAvatarButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.Layout.profileAvatarButtonCornerRadius
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(avatarImageTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(resource: .yBlack).withAlphaComponent(Constants.Color.avatarButtonBackgroundAlpha)
        let camera = UIImage(systemName: "camera.fill")
        button.setImage(camera, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var loadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: Constants.Layout.loadImageButtonFrameWidth, height: Constants.Layout.loadImageButtonFrameHeight)
        button.isHidden = true
        button.setTitle(NSLocalizedString("LoadImage", comment: ""), for: .normal)
        button.setTitleColor(UIColor(resource: .yBlack), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.Font.loadImageButtonSize, weight: Constants.Font.loadImageButtonWeight)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(loadImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Name", comment: "")
        label.textColor = UIColor(resource: .yBlack)
        label.font = UIFont.systemFont(ofSize: Constants.Font.sectionTitleSize, weight: Constants.Font.sectionTitleWeight)
        return label
    }()
    
    lazy var nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: Constants.Font.textViewSize, weight: Constants.Font.textViewWeight)
        textView.layer.cornerRadius = Constants.Layout.textViewCornerRadius
        textView.backgroundColor = UIColor(named: "LightGrayColor")
        textView.textContainerInset = UIEdgeInsets(top: Constants.Inset.textViewTop, left: Constants.Inset.textViewLeft, bottom: Constants.Inset.textViewBottom, right: Constants.Inset.textViewRight)
        textView.heightAnchor.constraint(equalToConstant: Constants.Layout.nameTextViewHeight).isActive = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var userInfoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Description", comment: "")
        label.textColor = UIColor(resource: .yBlack)
        label.font = UIFont.systemFont(ofSize: Constants.Font.sectionTitleSize, weight: Constants.Font.sectionTitleWeight)
        return label
    }()
    
    lazy var infoTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: Constants.Font.textViewSize, weight: Constants.Font.textViewWeight)
        textView.layer.cornerRadius = Constants.Layout.textViewCornerRadius
        textView.backgroundColor = UIColor(named: "LightGrayColor")
        textView.textContainerInset = UIEdgeInsets(top: Constants.Inset.textViewTop, left: Constants.Inset.textViewLeft, bottom: Constants.Inset.textViewBottom, right: Constants.Inset.textViewRight)
        textView.heightAnchor.constraint(equalToConstant: Constants.Layout.infoTextViewHeight).isActive = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var userSiteLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("WebSite", comment: "")
        label.textColor = UIColor(resource: .yBlack)
        label.font = UIFont.systemFont(ofSize: Constants.Font.sectionTitleSize, weight: Constants.Font.sectionTitleWeight)
        return label
    }()
    
    lazy var siteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: Constants.Font.textViewSize, weight: Constants.Font.textViewWeight)
        textView.layer.cornerRadius = Constants.Layout.textViewCornerRadius
        textView.backgroundColor = UIColor(named: "LightGrayColor")
        textView.textContainerInset = UIEdgeInsets(top: Constants.Inset.textViewTop, left: Constants.Inset.textViewLeft, bottom: Constants.Inset.textViewBottom, right: Constants.Inset.textViewRight)
        textView.heightAnchor.constraint(equalToConstant: Constants.Layout.siteTextViewHeight).isActive = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Сохранить", comment: ""), for: .normal) // ключ используем напрямую
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .yBlack)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.Font.saveButtonTitleSize, weight: Constants.Font.saveButtonTitleWeight)
        button.layer.cornerRadius = Constants.Layout.saveButtonCornerRadius
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addSubviews()
        setupConstraints()
        setupKeyboardHandling()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setChangePhotoButtonVisible(_ visible: Bool) {
        loadImageButton.isHidden = !visible
    }
    
    // Блокировка нижней кнопки «Сохранить»
    func setSaveButtonEnabled(_ enabled: Bool) {
        saveButton.isEnabled = enabled
        saveButton.alpha = enabled ? 1.0 : Constants.Alpha.disabled
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        let views: [UIView] = [
            closeButton,
            profileAvatar,
            profileAvatarButton,
            loadImageButton,
            nameLabel,
            nameTextView,
            userInfoLabel,
            infoTextView,
            userSiteLabel,
            siteTextView,
            bottomContainer
        ]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        bottomContainer.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // closeButton скрыт и не влияет на layout
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: -100),
            closeButton.heightAnchor.constraint(equalToConstant: 0),
            closeButton.widthAnchor.constraint(equalToConstant: 0),
            
            profileAvatar.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileAvatar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.avatarTop),
            profileAvatar.widthAnchor.constraint(equalToConstant: Constants.Layout.avatarSize),
            profileAvatar.heightAnchor.constraint(equalToConstant: Constants.Layout.avatarSize),
            
            profileAvatarButton.centerXAnchor.constraint(equalTo: profileAvatar.centerXAnchor),
            profileAvatarButton.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            profileAvatarButton.widthAnchor.constraint(equalToConstant: Constants.Layout.avatarButtonSize),
            profileAvatarButton.heightAnchor.constraint(equalToConstant: Constants.Layout.avatarButtonSize),
            
            loadImageButton.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: Constants.Layout.loadImageButtonTop),
            loadImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: Constants.Layout.nameLabelTop),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),
            
            nameTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.Layout.textViewTop),
            nameTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            nameTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),
            
            userInfoLabel.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: Constants.Layout.userInfoLabelTop),
            userInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            userInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),
            
            infoTextView.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: Constants.Layout.textViewTop),
            infoTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            infoTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),
            
            userSiteLabel.topAnchor.constraint(equalTo: infoTextView.bottomAnchor, constant: Constants.Layout.userSiteLabelTop),
            userSiteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            userSiteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),
            
            siteTextView.topAnchor.constraint(equalTo: userSiteLabel.bottomAnchor, constant: Constants.Layout.textViewTop),
            siteTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            siteTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),
            
            bottomContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            saveButton.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: Constants.Inset.saveButtonTop),
            saveButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: Constants.Inset.saveButtonHorizontal),
            saveButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -Constants.Inset.saveButtonHorizontal),
            saveButton.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: -Constants.Inset.saveButtonBottom),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.Layout.saveButtonHeight)
        ])
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.frame.origin.y = -keyboardFrame.height * Constants.Keyboard.shiftFactor
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.frame.origin.y = 0
    }
    
    @objc private func closeButtonTapped() {
        closeTapped?()
    }
    
    @objc private func loadImageButtonTapped() {
        avatarTapped?()
    }
    
    @objc private func avatarImageTapped() {
        avatarTapped?()
    }
    
    @objc private func saveButtonTapped() {
        onSaveTapped?()
    }
}

// MARK: - UITextViewDelegate

extension EditProfileView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case nameTextView:
            nameChanged?(textView.text)
        case infoTextView:
            infoChanged?(textView.text)
        case siteTextView:
            siteChanged?(textView.text)
        default:
            break
        }
    }
    
}

private extension EditProfileView {
    enum Constants {
        enum Layout {
            static let avatarTop: CGFloat = 22
            static let avatarSize: CGFloat = 70
            static let avatarButtonSize: CGFloat = 70
            
            static let loadImageButtonTop: CGFloat = 4
            static let loadImageButtonFrameWidth: CGFloat = 250
            static let loadImageButtonFrameHeight: CGFloat = 44
            
            static let nameLabelTop: CGFloat = 24
            static let textViewTop: CGFloat = 8
            static let userInfoLabelTop: CGFloat = 24
            static let userSiteLabelTop: CGFloat = 24
            static let horizontalPadding: CGFloat = 16
            
            static let nameTextViewHeight: CGFloat = 44
            static let infoTextViewHeight: CGFloat = 132
            static let siteTextViewHeight: CGFloat = 44
            
            static let profileAvatarCornerRadius: CGFloat = 35
            static let profileAvatarButtonCornerRadius: CGFloat = 35
            static let textViewCornerRadius: CGFloat = 12
            
            static let saveButtonCornerRadius: CGFloat = 16
            static let saveButtonHeight: CGFloat = 60
        }
        
        enum Inset {
            static let textViewTop: CGFloat = 11
            static let textViewLeft: CGFloat = 16
            static let textViewBottom: CGFloat = 11
            static let textViewRight: CGFloat = 16
            static let saveButtonTop: CGFloat = 8
            static let saveButtonBottom: CGFloat = 16
            static let saveButtonHorizontal: CGFloat = 16
        }
        
        enum Font {
            static let sectionTitleSize: CGFloat = 22
            static let sectionTitleWeight: UIFont.Weight = .bold
            
            static let textViewSize: CGFloat = 17
            static let textViewWeight: UIFont.Weight = .regular
            
            static let loadImageButtonSize: CGFloat = 17
            static let loadImageButtonWeight: UIFont.Weight = .regular
            
            static let saveButtonTitleSize: CGFloat = 17
            static let saveButtonTitleWeight: UIFont.Weight = .bold
        }
        
        enum Color {
            static let avatarButtonBackgroundAlpha: CGFloat = 0.6
            static let saveButtonBackgroundName: String = "YBlackColor"
        }
        
        enum Alpha {
            static let disabled: CGFloat = 0.6
        }
        
        enum Keyboard {
            static let shiftFactor: CGFloat = 0.5
        }
    }
}
