import UIKit
import Kingfisher

final class ProfileView: UIView {
    
    private let likesStorage = LikesStorageImpl.shared
    private var nftsCount: Int = Constraints.initialNFTsCount
    private var likesCount: Int = 0
    
    // MARK: - Public Callbacks (для контроллера)
    var websiteLabelTapped: ((String) -> Void)?
    var favoritesTapped: (() -> Void)?
    var aboutDeveloper: ((String) -> Void)?
    var myNFTTapped: (() -> Void)?
    
    // MARK: - UI Elements
    
    private lazy var profileAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constraints.avatarCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mock Name"
        label.textColor = UIColor(named: "YBlackColor")
        label.font = FontStyle.title
        return label
    }()
    
    private lazy var userWebSiteLabel: UILabel = {
        let label = UILabel()
        label.text = "practicum.yandex.ru"
        label.textColor = .systemBlue
        label.font = FontStyle.website
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnWebsiteLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    private lazy var profileInfoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("NoInformation", comment: "")
        label.textColor = UIColor(named: "YBlackColor")
        label.font = FontStyle.info
        label.numberOfLines = Constraints.infoNumberOfLines
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = Constraints.tableRowHeight
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        return tableView
    }()
    
    private lazy var profileContainerView = UIView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private UI setup
    private func setupLayout() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        [profileContainerView, profileTableView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [profileAvatar, userNameLabel, profileInfoLabel, userWebSiteLabel].forEach {
            profileContainerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constraints.containerTop),
            profileContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.horizontalPadding),
            profileContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constraints.horizontalPadding),
            
            profileAvatar.topAnchor.constraint(equalTo: profileContainerView.topAnchor),
            profileAvatar.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor),
            profileAvatar.widthAnchor.constraint(equalToConstant: Constraints.avatarSize),
            profileAvatar.heightAnchor.constraint(equalToConstant: Constraints.avatarSize),
            
            userNameLabel.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profileAvatar.trailingAnchor, constant: Constraints.nameToAvatarSpacing),
            
            profileInfoLabel.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: Constraints.infoTopSpacing),
            profileInfoLabel.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor),
            profileInfoLabel.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor),
            
            userWebSiteLabel.topAnchor.constraint(equalTo: profileInfoLabel.bottomAnchor, constant: Constraints.websiteTopSpacing),
            userWebSiteLabel.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor),
            userWebSiteLabel.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor),
            userWebSiteLabel.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor),
            
            profileTableView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: Constraints.tableTopSpacing),
            profileTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileTableView.heightAnchor.constraint(equalToConstant: Constraints.tableHeight)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapOnWebsiteLabel() {
        if let text = userWebSiteLabel.text {
            websiteLabelTapped?(text)
        }
    }
    
    // MARK: - Public API
    func updateUI(with profile: Profile) {
        userNameLabel.text = profile.name
        
        if let avatarURLString = profile.avatar, let url = URL(string: avatarURLString) {
            profileAvatar.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
        } else {
            profileAvatar.image = UIImage(systemName: "person.crop.circle")
        }
        
        if let website = profile.website {
            let cleanedWebsite = website
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
            userWebSiteLabel.text = cleanedWebsite
        } else {
            userWebSiteLabel.isHidden = true
        }
        
        profileInfoLabel.text = profile.description ?? NSLocalizedString("NoInformation", comment: "")
        
        self.nftsCount = profile.nfts.count
        self.likesCount = profile.likes.count
        
        profileTableView.reloadData()
    }
    
    func updateLikesCountAndUI() {
        let likes = likesStorage.getAllLikes()
        likesCount = likes.count
        profileTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constraints.tableRowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = NSLocalizedString("MyNFT", comment: "") + " (\(nftsCount))"
        case 1:
            cell.textLabel?.text = NSLocalizedString("Favorites", comment: "") + " (\(likesCount))"
        case 2:
            cell.textLabel?.text = NSLocalizedString("AboutDeveloper", comment: "")
        default:
            break
        }
        
        cell.textLabel?.font = FontStyle.cellTitle
        cell.textLabel?.textColor = UIColor(named: "YBlackColor")
        
        let chevronImage = UIImage(
            systemName: "chevron.forward",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: Constraints.chevronPointSize,
                weight: .regular,
                scale: .medium
            )
        )?.withRenderingMode(.alwaysTemplate)
        let chevronImageView = UIImageView(image: chevronImage)
        
        cell.accessoryView = chevronImageView
        cell.tintColor = UIColor(named: "YBlackColor")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            myNFTTapped?()
        case 1:
            favoritesTapped?()
        case 2:
            aboutDeveloper?("practicum.yandex.ru")
        default:
            break
        }
    }
}

private extension ProfileView {
    enum Constraints {
        static let containerTop: CGFloat = 20
        static let horizontalPadding: CGFloat = 16
        static let avatarSize: CGFloat = 70
        static let avatarCornerRadius: CGFloat = 35
        static let infoTopSpacing: CGFloat = 20
        static let websiteTopSpacing: CGFloat = 12
        static let tableTopSpacing: CGFloat = 40
        
        static let userNameFontSize: CGFloat = 22
        static let websiteFontSize: CGFloat = 15
        static let infoFontSize: CGFloat = 13
        static let infoNumberOfLines: Int = 5
        static let nameToAvatarSpacing: CGFloat = 16
        
        static let tableRowHeight: CGFloat = 54
        static let tableRowsCount: Int = 3
        static var tableHeight: CGFloat { tableRowHeight * CGFloat(tableRowsCount) }
        
        static let chevronPointSize: CGFloat = 17
        static let cellTextFontSize: CGFloat = 17
        
        static let initialNFTsCount: Int = 0
    }
    
    enum FontStyle {
        static let title = UIFont.systemFont(ofSize: Constraints.userNameFontSize, weight: .bold)
        static let website = UIFont.systemFont(ofSize: Constraints.websiteFontSize, weight: .regular)
        static let info = UIFont.systemFont(ofSize: Constraints.infoFontSize, weight: .regular)
        static let cellTitle = UIFont.systemFont(ofSize: Constraints.cellTextFontSize, weight: .bold)
    }
}
