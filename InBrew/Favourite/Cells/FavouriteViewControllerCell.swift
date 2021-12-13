//
//  FavouriteViewControllerCell.swift
//  InBrew
//
//  Created by golub_dobra on 24.11.2021.
//

import UIKit
import PinLayout
import Kingfisher

protocol FavouriteViewControllerCellDelegate: AnyObject {
    func didTapLikeBeer(isLiked: Bool, beerId: String)
}

final class FavouriteViewControllerCell: UICollectionViewCell {
    private let beerImage = UIImageView()
    private let beerNameLabel = UILabel()
    private let beerDescriptionLabel = UILabel()
    private let beerCostLabel = UILabel()
    private let likeBeerButton = UIButton()
    private let model: ImageLoaderProtocol = ImageLoader.shared
    private var beerId: String = ""
    weak var delegate: FavouriteViewControllerCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.primary.cgColor
        backgroundColor = .background
        
        
        beerImage.layer.cornerRadius = 15
        beerImage.layer.masksToBounds = true
        beerImage.layer.borderColor = UIColor.systemGray5.cgColor
        beerImage.layer.borderWidth = 1
        beerImage.contentMode = .scaleAspectFit
        
        beerNameLabel.font = UIFont(name: "Comfortaa-Bold", size: 16)
        beerNameLabel.textColor = .text
        
        beerDescriptionLabel.font = UIFont(name: "Comfortaa-Bold", size: 12)
        beerDescriptionLabel.textColor = .minorText
        
        beerCostLabel.font = UIFont(name: "Comfortaa-Bold", size: 18)
        beerCostLabel.textColor = .text
        
        likeBeerButton.tintColor = .primary
        likeBeerButton.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)

        likeBeerButton.addTarget(self, action: #selector(didTapLikeBeerInCell), for: .touchUpInside)
        
        
        [beerImage,
         beerNameLabel,
         beerDescriptionLabel,
         beerCostLabel,
         likeBeerButton].forEach() {
            addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        beerImage.image = nil
        beerImage.kf.cancelDownloadTask()
    }
    
    func configure(with favouriteCell: Product) {
        beerNameLabel.text = favouriteCell.name
        beerDescriptionLabel.text = favouriteCell.sort + ", " + favouriteCell.categories
        beerCostLabel.text = favouriteCell.price
        beerId = favouriteCell.id
        if favouriteCell.isFavourite {
            likeBeerButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            likeBeerButton.restorationIdentifier = "heart.fill"
        } else {
            likeBeerButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
            likeBeerButton.restorationIdentifier = "heart"
        }
        
        if let imUrl = model.getCacheUrl(id: favouriteCell.id) {
            beerImage.kf.setImage(with: imUrl)
        }
        
        model.getBeerImageUrl(beerId: favouriteCell.id) { [weak self] result in
            switch result {
            case .success(let url):
                self?.beerImage.kf.indicatorType = .activity
                self?.beerImage.kf.setImage(with: url,
                                            options: [
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
            case .failure(let error):
                print("[DEBUG]: \(error)")
                self?.beerImage.image = UIImage(named: "defaultIcon")
            }
        }
    }
    
    override func layoutSubviews() {
        beerImage.pin
            .top()
            .horizontally()
            .height(150)
        
        beerNameLabel.pin
            .below(of: beerImage)
            .marginTop(10)
            .left(10)
            .height(15)
            .sizeToFit(.height)
        
        beerDescriptionLabel.pin
            .below(of: beerNameLabel)
            .marginTop(4)
            .left(10)
            .height(15)
            .sizeToFit(.height)
        
        beerCostLabel.pin
            .below(of: beerDescriptionLabel)
            .marginTop(7)
            .left(10)
            .height(20)
            .sizeToFit(.height)
        
        likeBeerButton.pin
            .bottomRight(13)
            .marginTop(18)
            .height(26)
            .width(31)
    }
    
    @objc
    func didTapLikeBeerInCell() {
        if likeBeerButton.restorationIdentifier == "heart.fill" {
            likeBeerButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
            likeBeerButton.restorationIdentifier = "heart"
            delegate?.didTapLikeBeer(isLiked: true, beerId: beerId)
            
        } else if likeBeerButton.restorationIdentifier == "heart" {
            likeBeerButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            likeBeerButton.restorationIdentifier = "heart.fill"
            delegate?.didTapLikeBeer(isLiked: false, beerId: beerId)
        }
    }
}
