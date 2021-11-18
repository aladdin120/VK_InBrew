//
//  CategoryCellCollectionViewCell.swift
//  InBrew
//
//  Created by Fedo on 31.10.2021.
//

import UIKit
import Kingfisher

final class NetworkImageView: UIImageView {
    func setURL(_ url: URL?) {
        kf.setImage(with: url)
    }
}

final class CategoryCellCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCellCollectionViewCell"
    
    private let categoryImageView = NetworkImageView()
    private let nameLabel =  UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContentView()
        setupImageView()
        setupLabel()
    }
    
    func setupContentView() {
        contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemYellow.cgColor
    }
    
    func setupImageView() {
        categoryImageView.contentMode = .scaleAspectFill
        categoryImageView.layer.cornerRadius = 20
        categoryImageView.layer.borderWidth = 1
        categoryImageView.layer.borderColor = UIColor.systemYellow.cgColor
        categoryImageView.clipsToBounds = true
        contentView.addSubview(categoryImageView)
    }
    
    func setupLabel() {
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: Category) {
        nameLabel.text = category.name
        categoryImageView.setURL(category.iconUrl)
    }
    
    override func layoutSubviews() {
        categoryImageView.pin
            .top(15)
            .horizontally(10)
            .height(120)
            
        
        nameLabel.pin
            .bottom(20)
            .horizontally(pin.safeArea)
            .height(20)
    }
}
