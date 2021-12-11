//
//  ProductCollectionViewCell.swift
//  InBrew
//
//  Created by fedo on 07.11.2021.
//

import Foundation
import UIKit
import Kingfisher


final class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCollectionViewCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()
    private let favButton = UIButton()
    
    private let model: ImageLoaderProtocol = ImageLoader.shared
    private let databaseModel: DatabaseModel = DatabaseModel()
    private var product: Product?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContentView()
        setupLabels()
        setupImageView()
        setupButton()
    }
    
    func setupButton() {
        favButton.setImage(UIImage(named: "favouriteIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favButton.tintColor = .primary
        favButton.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 0)
        favButton.imageView?.contentMode = .scaleAspectFit
        favButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        contentView.addSubview(favButton)
    }
    
    func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.primary.cgColor
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
    
    @objc
    func didTapLikeButton() {
        guard let productId = product?.id else {
            print("[DEBUG]: Not find product id!")
            return
        }
        
        if favButton.restorationIdentifier == "heart" {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favButton.restorationIdentifier = "heart.fill"
            
            databaseModel.addFavouriteBeerInDatabase(beerId: productId) {  document in
                switch document {
                case .success(_):
                    print("[DEBUG]: addFavouriteBeerInDatabase")
                    
                case .failure(_):
                    print("[DEBUG]: \(FirebaseError.emptyDocumentData)")
                }
            }
            
        } else if favButton.restorationIdentifier == "heart.fill" {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favButton.restorationIdentifier = "heart"
            
            databaseModel.removeFavouriteBeerFromDatabase(beerId: productId) { document in
                switch document {
                case .success(_):
                    print("[DEBUG]: removeFavouriteBeerFromDatabase")
                 
                case .failure(_):
                    print("[DEBUG]: \(FirebaseError.emptyDocumentData)")
                }
            }
        }
        
        ProductsManager.shared.getAllBeer { result in
            switch result {
            case .success(_):
                return
                
            case .failure(_):
                return
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: Product) {
        self.product = product
        nameLabel.text = product.name
        categoryLabel.text = product.sort + ", " + product.categories
        priceLabel.text = product.price
        if let imUrl = model.getCacheUrl(beerId: product.id) {
            imageView.kf.setImage(with: imUrl)
        }
        
        if product.isFavourite {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favButton.restorationIdentifier = "heart.fill"
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favButton.restorationIdentifier = "heart"
        }
        
        model.getBeerImageUrl(beerId: product.id) { [weak self] result in
            switch result {
            case .success(let url):
                self?.imageView.kf.indicatorType = .activity
                self?.imageView.kf.setImage(with: url,
                                            options: [
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
            case .failure(let error):
                print("[DEBUG]: \(error)")
                self?.imageView.image = UIImage(named: "defaultIcon")
            }
        }
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
    }
}
