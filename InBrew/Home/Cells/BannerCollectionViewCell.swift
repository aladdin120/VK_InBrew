//
//  BannerCollectionViewCell.swift
//  InBrew
//
//  Created by Fedo on 04.11.2021.
//

import UIKit

final class BannerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BannerCollectionViewCell"
    
    private let categoryImageView = NetworkImageView()
    private let nameLabel =  UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContentView()
    }
    
    func setupContentView() {
        contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemYellow.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {

    }
}
