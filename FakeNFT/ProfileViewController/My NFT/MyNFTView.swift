
import UIKit
import Kingfisher


final class MyNFTView: UIView {
    
    var nftItems: [MyNFT] = [] {
        didSet {
            updateUI()
            nftTableView.reloadData()
        }
    }
    
    var isLiked: ((String) -> Bool)?
    var likeButtonTapped: ((String) -> Void)?
    
    lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NFTCell.self, forCellReuseIdentifier: NFTCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("noNFTs", comment: "")
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(resource: .yBlack)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "ETH"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(nftTableView)
        addSubview(placeholderLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            nftTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nftTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func updateUI() {
        placeholderLabel.isHidden = !nftItems.isEmpty
    }
    
    func updateNFTs(with nfts: [MyNFT]) {
        nftItems = nfts
        nftTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MyNFTView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: NFTCell.reuseIdentifier, for: indexPath)
        let cell = (dequeued as? NFTCell) ?? {
            assertionFailure("Dequeued cell is not NFTCell. Check registration and reuseIdentifier.")
            return NFTCell(style: .default, reuseIdentifier: NFTCell.reuseIdentifier)
        }()
        
        let nft = nftItems[indexPath.row]
        let formattedPrice = numberFormatter.string(from: nft.price as NSNumber) ?? "\(nft.price) ETH"
        let liked = isLiked?(nft.id) ?? false
        cell.configure(with: nft, isLiked: liked, formattedPrice: formattedPrice)
        cell.selectionStyle = .none
        cell.likeButtonTapped = { [weak self] in
            self?.likeButtonTapped?(nft.id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

