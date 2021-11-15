//
//  ProductCollectionViewCell.swift
//  InBrew
//
//  Created by Ольга Лемешева on 07.11.2021.
//

import Foundation
import UIKit
import Kingfisher

final class NetworkImageView: UIImageView {
    func setURL(_ url: URL?) {
        kf.setImage(with: url)
    }
}

final class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCollectionViewCell"
    
    private let imageView = NetworkImageView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()
    private let favButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContentView()
        setupLabels()
        setupImageView()
        setupButton()
    }
    
    func setupButton() {
        favButton.setImage(UIImage(named: "favouriteIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favButton.tintColor = .systemYellow
        contentView.addSubview(favButton)
    }
    
    func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemYellow.cgColor
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    func setupLabels() {
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        categoryLabel.font = .systemFont(ofSize: 14, weight: .light)
        categoryLabel.textColor = .systemGray
        priceLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        categoryLabel.text = product.categories
        priceLabel.text = product.price
        imageView.setURL(product.iconUrl)
    }
    
    override func layoutSubviews() {
        imageView.pin
            .top()
            .horizontally()
            .height(150)
        
        nameLabel.pin
            .below(of: imageView)
            .marginTop(10)
            .left(10)
            .height(15)
            .sizeToFit(.height)
        
        categoryLabel.pin
            .below(of: nameLabel, aligned: .left)
            .marginTop(4)
            .height(15)
            .sizeToFit(.height)
        
        priceLabel.pin
            .below(of: categoryLabel, aligned: .left)
            .marginTop(7)
            .height(20)
            .sizeToFit(.height)
        
        favButton.pin
            .size(30)
            .bottomRight(10)
    }
}
