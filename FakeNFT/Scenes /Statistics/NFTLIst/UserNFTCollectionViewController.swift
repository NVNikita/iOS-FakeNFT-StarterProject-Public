import UIKit

final class UserNFTCollectionViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: UserNFTCollectionViewOutput
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        
        let edgePadding: CGFloat = 16
        let itemSpacing: CGFloat = 9
        
        let totalHorizontalPadding = edgePadding * 2 + itemSpacing * 2
        let itemWidth = floor((screenWidth - totalHorizontalPadding) / 3)
        let itemHeight = itemWidth * 1.5
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = 28
        layout.sectionInset = UIEdgeInsets(top: edgePadding, left: edgePadding, bottom: edgePadding, right: edgePadding)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.register(UserNFTCell.self, forCellWithReuseIdentifier: UserNFTCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У пользователя нет NFT"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(presenter: UserNFTCollectionViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        
        if let presenter = presenter as? UserNFTCollectionPresenter {
            presenter.view = self
        }
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Коллекция NFT"
        
        let backImage = UIImage(named: "back_icon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
    }
    
    // MARK: - Actions
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UserNFTCollectionViewInput
extension UserNFTCollectionViewController: UserNFTCollectionViewInput {
    func showLoading() {
        activityIndicator.startAnimating()
        collectionView.isHidden = true
        emptyLabel.isHidden = true
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
    }
    
    func displayNFTs() {
        collectionView.reloadData()
    }
    
    func showEmptyState(isVisible: Bool) {
        collectionView.isHidden = isVisible
        emptyLabel.isHidden = !isVisible
    }
    
    func showError(message: String) {
        showAlert(title: "Ошибка", message: message)
    }
}

// MARK: - UICollectionViewDataSource
extension UserNFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.nftsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserNFTCell.reuseIdentifier,
            for: indexPath
        ) as? UserNFTCell else {
            return UICollectionViewCell()
        }
        
        let nftModel = presenter.nft(at: indexPath.item)
        cell.configure(with: nftModel)
        return cell
    }
}
