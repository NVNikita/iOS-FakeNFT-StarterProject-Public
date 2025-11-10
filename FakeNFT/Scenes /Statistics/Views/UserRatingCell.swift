import UIKit

final class UserRatingCell: UITableViewCell {

    // MARK: - UI Elements
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Light grey")
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Identifier
    
    static let reuseIdentifier = "UserRatingCell"
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(named: "White")
        
        contentView.addSubview(rankLabel)
        contentView.addSubview(cardView)
        
        cardView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(nftCountLabel)
        
        selectionStyle = .none
    }
        
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // 1. Rank Label
            rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rankLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 27),
            
            // 2. Card View - отступ снизу 8px между ячейками
            cardView.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 8),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8), // ← 8px отступ
            cardView.heightAnchor.constraint(equalToConstant: 80),
            
            // 3. Avatar
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            
            // 4. Name Label
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: nftCountLabel.leadingAnchor, constant: -8),
            
            // 5. NFT Count Label
            nftCountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            nftCountLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with user: User, rank: Int) {
        rankLabel.text = "\(rank)"
        nameLabel.text = user.name
        nftCountLabel.text = "\(user.nftCount)"

        let avatarURLString = user.avatar
        
        if let urlString = avatarURLString, !urlString.isEmpty {
            // TODO: Загрузка изображения по URL
            avatarImageView.image = nil
            avatarImageView.backgroundColor = .systemGray5
        } else {
            avatarImageView.image = UIImage(named: "userPFP")
            avatarImageView.backgroundColor = .clear
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
        nftCountLabel.text = nil
        rankLabel.text = nil
    }
}
