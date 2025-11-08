//
//  CurrencyCollectionViewCell.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 08.11.2025.
//

import UIKit

final class CurrencyCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleCellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular13SFPro
        label.textColor = UIColor.blackYP
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular13SFPro
        label.textColor = UIColor.greenYP
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor.lightGreyYP
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageViewCell)
        contentView.addSubview(titleCellLabel)
        contentView.addSubview(currencyLabel)
        
        imageViewCell.translatesAutoresizingMaskIntoConstraints = false
        titleCellLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageViewCell.heightAnchor.constraint(equalToConstant: 36),
            imageViewCell.widthAnchor.constraint(equalToConstant: 36),
            
            titleCellLabel.topAnchor.constraint(equalTo: imageViewCell.topAnchor),
            titleCellLabel.leadingAnchor.constraint(equalTo: imageViewCell.trailingAnchor, constant: 4),
            
            currencyLabel.bottomAnchor.constraint(equalTo: imageViewCell.bottomAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: imageViewCell.trailingAnchor, constant: 4)
        ])
    }
    
    func config(title: String, name: String, image: UIImage?) {
        self.imageViewCell.image = image
        self.titleCellLabel.text = title
        self.currencyLabel.text = name
    }
}
