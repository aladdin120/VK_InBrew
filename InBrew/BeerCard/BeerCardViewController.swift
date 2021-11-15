//
//  BeerCardViewController.swift
//  InBrew
//
//  Created by golub_dobra on 10.11.2021.
//

import UIKit
import PinLayout

final class BeerCardViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let beerImage = UIImageView(image: UIImage(named: "beerTest.jpeg"))
    private let beerTitleLabel = UILabel()
    private let likeOfBeerButton = UIButton()
    private let beerContryLabel = UILabel()
    private let beerCostLabel = UILabel()
    private let costSeparator = UIView()
    private let beerDetailTitleLable = UILabel()
    private let beerDetailDescriptionLabel = UILabel()
    private let descriptionSeparator = UIView()
    private let showBeerReviewButton = UIButton()
    private let ratingStarsImage = UIImageView(image: UIImage(systemName: "star"))
    private let goToReviewScreenImage = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let addReviewButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        
        scrollView.alwaysBounceVertical = true
        
        beerImage.contentMode = .scaleAspectFill
        beerImage.clipsToBounds = true
        beerImage.alpha = 0.9
        beerImage.layer.cornerRadius = 25
        beerImage.layer.masksToBounds = true
        beerImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        beerTitleLabel.text = "Охота выдержанное выдержанное выдержанное выдержанное"
        beerTitleLabel.font = UIFont(name: "Comfortaa-Bold", size: 24)
        beerTitleLabel.textColor = .text
        beerTitleLabel.lineBreakMode = .byWordWrapping
        beerTitleLabel.numberOfLines = 0
        
        likeOfBeerButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeOfBeerButton.restorationIdentifier = "heart"
        likeOfBeerButton.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 0)
        likeOfBeerButton.imageView?.contentMode = .scaleAspectFit
        likeOfBeerButton.tintColor = .primary
        likeOfBeerButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        beerContryLabel.text = "Russia"
        beerContryLabel.font = UIFont(name: "Comfortaa-Bold", size: 16)
        beerContryLabel.textColor = .minorText
        
        beerCostLabel.text = "45руб"
        beerCostLabel.font = UIFont(name: "Comfortaa-Bold", size: 24)
        beerCostLabel.textColor = .text
        
        [costSeparator,descriptionSeparator].forEach() {
            ($0).backgroundColor = .separator
        }
        beerDetailTitleLable.numberOfLines = 0
        beerDetailTitleLable.text = "Product DetailProduct"
        beerDetailTitleLable.font = UIFont(name: "Comfortaa-Bold", size: 16)
        beerDetailTitleLable.textColor = .text
        
        beerDetailDescriptionLabel.text = "Strong, bottom-fermented dark beer with rich taste and seductive aroma."
        beerDetailDescriptionLabel.font = UIFont(name: "Comfortaa-Bold", size: 13)
        beerDetailDescriptionLabel.textColor = .minorText
        beerDetailDescriptionLabel.lineBreakMode = .byWordWrapping
        beerDetailDescriptionLabel.numberOfLines = 0
        
        showBeerReviewButton.setTitle("Review", for: .normal)
        showBeerReviewButton.setTitleColor(.text, for: .normal)
        showBeerReviewButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 16)
        showBeerReviewButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: view.frame.width)
        showBeerReviewButton.addTarget(self, action: #selector(didTapShowReviewButton), for: .touchUpInside)
        
        ratingStarsImage.tintColor = .primary
        
        goToReviewScreenImage.tintColor = .text
        
        addReviewButton.backgroundColor = .primary
        addReviewButton.setTitle("Write a review", for: .normal)
        addReviewButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 18)
        addReviewButton.titleLabel?.tintColor = .lightText
        addReviewButton.layer.cornerRadius = 19
        addReviewButton.addTarget(self, action: #selector(didTapWriteReviewButton), for: .touchUpInside)
        
        [beerImage,
         beerTitleLabel,
         likeOfBeerButton,
         beerContryLabel,
         beerCostLabel,
         costSeparator,
         beerDetailTitleLable,
         beerDetailDescriptionLabel,
         descriptionSeparator,
         showBeerReviewButton,
         ratingStarsImage,
         goToReviewScreenImage,
         addReviewButton].forEach() {
            scrollView.addSubview($0)
        }
        view.addSubview(scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backImage = UIImage(systemName: "chevron.backward")
        let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButtonItem
        navigationController?.navigationBar.tintColor = .primary
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin
            .all()
        
        beerImage.pin
            .top(-(navigationController?.navigationBar.frame.height  ?? 0) - view.pin.safeArea.top)
            .width(view.bounds.width)
            .height(view.bounds.width)
        
       
        likeOfBeerButton.pin
            .below(of: beerImage)
            .marginTop(18)
            .right(19)
            .height(26)
            .width(31)
        
        beerTitleLabel.pin
            .below(of: beerImage)
            .before(of: likeOfBeerButton)
            .width(view.bounds.width - likeOfBeerButton.frame.width)
            .minHeight(37)
            .maxHeight(105)
            .marginTop(18)
            .left(21)
        
        beerContryLabel.pin
            .below(of: beerTitleLabel)
            .marginTop(11)
            .left(21)
            .sizeToFit()
        
        beerCostLabel.pin
            .below(of: beerContryLabel)
            .marginTop(6)
            .right(10)
            .sizeToFit()
        
        costSeparator.pin
            .below(of: beerCostLabel)
            .marginTop(11)
            .horizontally(6)
            .height(0.1)
        
        beerDetailTitleLable.pin
            .below(of: costSeparator)
            .marginTop(17)
            .horizontally(30)
            .sizeToFit(.width)
        
        beerDetailDescriptionLabel.pin
            .below(of: beerDetailTitleLable)
            .horizontally(30)
            .marginTop(0)
            .sizeToFit(.width)
        
        descriptionSeparator.pin
            .below(of: beerDetailDescriptionLabel)
            .marginTop(12)
            .horizontally(6)
            .height(0.1)
        
        goToReviewScreenImage.pin
            .below(of: descriptionSeparator)
            .right(23)
            .marginTop(13)
            .sizeToFit()
        
        ratingStarsImage.pin
            .below(of: descriptionSeparator)
            .before(of: goToReviewScreenImage)
            .marginRight(17)
            .marginTop(11)
            .sizeToFit()
        
        showBeerReviewButton.pin
            .below(of: descriptionSeparator)
            .before(of: goToReviewScreenImage)
            .marginTop(11)
            .left()
            .sizeToFit()
        
        addReviewButton.pin
            .below(of: showBeerReviewButton)
            .marginTop(28)
            .horizontally(5)
            .height(67)
        
        scrollView.contentSize = CGSize(width: view.bounds.width, height: beerDetailDescriptionLabel.frame.maxY)
        
    }
    
    @objc
    func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapShowReviewButton() {
        print("[DEBUG:] Show Review!")
    }
    
    @objc
    func didTapWriteReviewButton() {
        print("[DEBUG:] Write a review!")
    }
    
    @objc
    func didTapLikeButton() {
        if likeOfBeerButton.restorationIdentifier == "heart" {
            likeOfBeerButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeOfBeerButton.restorationIdentifier = "heart.fill"
        } else if likeOfBeerButton.restorationIdentifier == "heart.fill" {
            likeOfBeerButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeOfBeerButton.restorationIdentifier = "heart"
        }
        
    }
}
