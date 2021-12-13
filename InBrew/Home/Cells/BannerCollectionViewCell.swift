//
//  BannerCollectionViewCell.swift
//  InBrew
//
//  Created by Fedo on 04.11.2021.
//

import UIKit
import PinLayout

final class BannerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BannerCollectionViewCell"
    
    private let categoryImageView = NetworkImageView()
    private let nameLabel =  UILabel()
    private let mysteryImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContentView()
        setupLabel()
        setupImage()
    }
    
    func setupContentView() {
        contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.primary.cgColor
    }
    
    func setupLabel() {
        nameLabel.text = "Brew \n Of \n the Day"
        nameLabel.font = .systemFont(ofSize: 37, weight: .bold)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
    }
    
    func setupImage() {
        mysteryImageView.image = UIImage(named: "mystery_beer")
        mysteryImageView.contentMode = .scaleAspectFit
        contentView.addSubview(mysteryImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.pin
            .top(10)
            .left(10)
            .width(50%)
            .bottom(10)
        
        mysteryImageView.pin
            .top(10)
            .after(of: nameLabel)
            .bottom(10)
            .right(10)

    }
}
