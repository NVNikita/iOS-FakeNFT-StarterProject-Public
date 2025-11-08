//
//  NFTTableViewCell.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 26.10.2025.
//

import UIKit

final class NFTTableViewCell: UITableViewCell {
    
    lazy var imageNFT: UIImageView = {
        let imageNFT = UIImageView()
        imageNFT.contentMode = .scaleAspectFit
        imageNFT.layer.masksToBounds = true
        imageNFT.layer.cornerRadius = 12
        return imageNFT
    }()
    
    lazy var nameNFTLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold17SFPro
        label.textColor = .black
        return label
    }()
    
    lazy var ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular13SFPro
        label.textColor = .black
        label.text = "Цена"
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold17SFPro
        label.textColor = .black
        return label
    }()
    
    lazy var deletedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(deletedButtonTap), for: .touchUpOutside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        activateUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func activateUI() {
        contentView.addSubview(imageNFT)
        contentView.addSubview(nameNFTLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(deletedButton)
        
        imageNFT.translatesAutoresizingMaskIntoConstraints = false
        nameNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        deletedButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageNFT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageNFT.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageNFT.heightAnchor.constraint(equalToConstant: 108),
            imageNFT.widthAnchor.constraint(equalToConstant: 108),
            
            nameNFTLabel.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            nameNFTLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameNFTLabel.heightAnchor.constraint(equalToConstant: 22),
            
            ratingStackView.leadingAnchor.constraint(equalTo: nameNFTLabel.leadingAnchor),
            ratingStackView.topAnchor.constraint(equalTo: nameNFTLabel.bottomAnchor, constant: 4),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameNFTLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: imageNFT.bottomAnchor, constant: -8),
            priceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            priceTitleLabel.leadingAnchor.constraint(equalTo: nameNFTLabel.leadingAnchor),
            priceTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            priceTitleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -2),
            
            deletedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deletedButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            deletedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            deletedButton.heightAnchor.constraint(equalToConstant: 40),
            deletedButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setRating(_ rating: Int) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            
            if i < rating {
                starImageView.image = UIImage(systemName: "star.fill")
                starImageView.tintColor = .systemYellow
            } else {
                starImageView.image = UIImage(systemName: "star.fill")
                starImageView.tintColor = .systemGray
            }
            
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    func config(image: UIImage?, nameNFT: String, rating: Int, priceNFT: String) {
        imageNFT.image = image
        nameNFTLabel.text = nameNFT
        priceLabel.text = priceNFT
        setRating(rating)
    }
    
    @objc func deletedButtonTap() {
        print("Test tap on deleted button")
    }
}
