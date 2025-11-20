import UIKit

final class UserNFTCell: UICollectionViewCell {

    static let reuseIdentifier = "UserNFTCell"

    private var onCartTap: (() -> Void)?

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()

    private let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cart_btn"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { return nil }

    private func setupUI() {
        contentView.addSubview(nftImageView)

        let textStack = UIStackView(arrangedSubviews: [
            ratingStack,
            titleLabel,
            priceLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let infoContainer = UIStackView(arrangedSubviews: [
            textStack,
            cartButton
        ])
        infoContainer.axis = .horizontal
        infoContainer.alignment = .center
        infoContainer.spacing = 8
        infoContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(infoContainer)
        
        ratingStack.setContentCompressionResistancePriority(.required, for: .horizontal)
        ratingStack.setContentHuggingPriority(.required, for: .horizontal)
        

        cartButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cartButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        textStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        cartButton.setContentHuggingPriority(.required, for: .horizontal)
        cartButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),

            infoContainer.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            infoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoContainer.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    func configure(with model: UserNFTCellModel) {
        titleLabel.text = model.title
        priceLabel.text = model.priceString
        priceLabel.isHidden = model.priceString == nil
        
        setStars(model.rating ?? 0)
        ratingStack.isHidden = model.rating == nil
        
        self.onCartTap = model.onCartTap
        
        if let url = model.imageURL {
            nftImageView.setImage(from: url, placeholder: nil)
        } else {
            nftImageView.cancelLoading()
            nftImageView.image = nil
        }
    }
    
    @objc private func didTapCartButton() {
        onCartTap?()
    }

    private func setStars(_ rating: Int) {
        ratingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for i in 1...5 {
            let iv = UIImageView(
                image: UIImage(named: i <= rating ? "starActive" : "starNoActive")
            )
            iv.tintColor = .systemYellow
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                iv.widthAnchor.constraint(equalToConstant: 12),
                iv.heightAnchor.constraint(equalToConstant: 12)
            ])

            ratingStack.addArrangedSubview(iv)
            iv.setContentCompressionResistancePriority(.required, for: .horizontal)
            iv.setContentHuggingPriority(.required, for: .horizontal)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        priceLabel.text = nil
        nftImageView.cancelLoading()
        nftImageView.image = nil
        ratingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        onCartTap = nil
    }
}
