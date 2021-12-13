//
//  ReviewViewController.swift
//  InBrew
//
//  Created by golub_dobra on 14.12.2021.
//

import UIKit
import PinLayout

final class ReviewViewController: UIViewController {
    private let userNameLabel = UILabel()
    private let userReviewImageView = UIImageView(image: UIImage())
    private let poductReviewImageView = UIImageView(image: UIImage())
    private let productReviewTextLabel = UILabel()
    private let productReviewRatingLabel = UILabel()
    private let container = UIView()
    private let model: ImageLoaderProtocol = ImageLoader.shared
    
    var review: ReviewModel = ReviewModel(id: "",
                                          rating: 0,
                                          review: "",
                                          uid: "",
                                          name: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .none
        
        userNameLabel.font = UIFont(name: "Comfortaa-Bold", size: 24)
        userNameLabel.textColor = .text
        
        [userReviewImageView,
         poductReviewImageView].forEach() {
            ($0).contentMode = .scaleAspectFill
            ($0).clipsToBounds = true
         }
        
        userReviewImageView.layer.cornerRadius = userReviewImageView.frame.size.height/2
        userReviewImageView.image = UIImage(named: "profileIcon")?.withTintColor(.primary)
        
        poductReviewImageView.layer.cornerRadius = 15
        poductReviewImageView.layer.borderWidth = 1
        poductReviewImageView.layer.borderColor = UIColor.systemGray5.cgColor
        
        productReviewTextLabel.font = UIFont(name: "Comfortaa-Bold", size: 18)
        productReviewTextLabel.textColor = .text
        productReviewTextLabel.lineBreakMode = .byWordWrapping
        productReviewTextLabel.numberOfLines = 0
        
        container.backgroundColor = .background
        container.layer.cornerRadius = 25
                
        configure(with: review)
        
        [userNameLabel,
         userReviewImageView,
         poductReviewImageView,
         productReviewTextLabel,
         productReviewRatingLabel].forEach {
            container.addSubview($0)
         }
        view.addSubview(container)
    }
    
    func configure(with review: ReviewModel) {
        
        userNameLabel.text = review.name
        productReviewTextLabel.text = review.review
        model.getReviewImage(reviewId: review.id) {[weak self] result in
            switch result {
            case .success(let img):
                self?.poductReviewImageView.image = img
            case .failure(let error):
                print("[DEBUG]: \(error)")
                self?.poductReviewImageView.image = UIImage(named: "emptyIcon")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.pin
            .bottom()
            .horizontally()
        
        poductReviewImageView.pin
            .bottom()
            .marginBottom(view.pin.safeArea.bottom + 16)
            .left()
            .marginLeft(31)
            .height(200)
            .width(200)
        
        productReviewTextLabel.pin
            .above(of: poductReviewImageView)
            .left()
            .marginBottom(16)
            .marginLeft(31)
            .right()
            .marginRight(21)
            .sizeToFit(.width)
        
        userReviewImageView.pin
            .above(of: productReviewTextLabel)
            .marginBottom(20)
            .marginTop(16)
            .left(21)
            .height(75)
            .width(75)
        
        userNameLabel.pin
            .after(of: userReviewImageView)
            .above(of: productReviewTextLabel)
            .marginBottom(40)
            .marginLeft(21)
            .right()
            .marginRight(21)
            .sizeToFit(.width)
        
        container.pin
            .wrapContent(.vertically)
        
    }
    
}


