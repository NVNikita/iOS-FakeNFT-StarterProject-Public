import UIKit
import WebKit

final class UserViewController: UIViewController {
    
    private let presenter: UserViewOutput
    private var nftCount: Int = 0
    
    // MARK: - UI Elements
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.backgroundColor = .tertiarySystemFill
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 4
        return label
    }()
    
    private lazy var siteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.addTarget(self, action: #selector(didTapSiteButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UserCollectionCell.self, forCellReuseIdentifier: UserCollectionCell.reuseIdentifier)
        table.separatorStyle = .none
        table.rowHeight = 54
        table.dataSource = self
        table.delegate = self
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        return table
    }()
    
    // MARK: - Initialization
    
    init(presenter: UserViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.hidesBackButton = true
        let backImage = UIImage(named: "back_icon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        
        view.addSubview(avatar)
        view.addSubview(nameLabel)
        view.addSubview(bioLabel)
        view.addSubview(siteButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Avatar
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            
            // Name Label
            nameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            // Bio Label
            bioLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // Site Button
            siteButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 28),
            siteButton.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            siteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            siteButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 41),
            tableView.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 54),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSiteButton() {
        presenter.didTapWebsiteButton()
    }
}

// MARK: - UserViewInput

extension UserViewController: UserViewInput {
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayUser(name: String, bio: String, avatarURL: URL?, nftCount: Int, websiteVisible: Bool) {
        self.nftCount = nftCount
        nameLabel.text = name
        bioLabel.text = bio
        siteButton.isHidden = !websiteVisible
        
        if let url = avatarURL {
            avatar.setImage(from: url, placeholder: UIImage(named: "userPFP"))
        } else {
            avatar.cancelLoading()
            avatar.image = UIImage(named: "userPFP")
        }
        
        tableView.reloadData()
    }
    
    func navigateToWeb(url: URL) {
        let webVC = StatisticsWebViewController(url: url, title: .none)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func navigateToNFTCollection(nftIDs: [String]) {
        let service: UserNFTCollectionServiceProtocol = UserNFTCollectionService()
        let presenter = UserNFTCollectionPresenter(service: service, nftIDs: nftIDs)
        let vc = UserNFTCollectionViewController(presenter: presenter)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension UserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? UserCollectionCell else {
            return UITableViewCell()
        }
        
        cell.configure(count: nftCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectNFTCollection()
    }
}
