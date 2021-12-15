//
//  ReviewsCell.swift
//  InBrew
//
//  Created by golub_dobra on 12.12.2021.
//

import UIKit
import PinLayout

class ReviewsCell: UITableViewCell {
    private let userNameLabel = UILabel()
    private let starsModule = StarsModule(frame: CGRect(x: 0, y: 30, width: Int((5*starSize) + (4*starSpasing)), height: Int(starSize)))
    private let userReviewImageView = UIImageView(image: UIImage())
    private let poductReviewImageView = UIImageView(image: UIImage())
    private let productReviewTextLabel = UILabel()
    private let productReviewRatingLabel = UILabel()
    private let separatorReview = UIView()
    private let model: ImageLoaderProtocol = ImageLoader.shared
    
    private var review: ReviewModel?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        userNameLabel.font = UIFont(name: "Comfortaa-Bold", size: 18)
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
        
        productReviewTextLabel.font = UIFont(name: "Comfortaa-Bold", size: 13)
        productReviewTextLabel.textColor = .text
        productReviewTextLabel.numberOfLines = 0
        productReviewTextLabel.adjustsFontSizeToFitWidth = false
        productReviewTextLabel.lineBreakMode = .byTruncatingTail
        
        separatorReview.backgroundColor = .primary
        
        [userReviewImageView,
         userNameLabel,
         starsModule,
         productReviewTextLabel,
         poductReviewImageView,
         separatorReview].forEach() {
            contentView.addSubview($0)
         }
    }
    
    func configure(with reviewsCell: ReviewModel) {
        review = reviewsCell

        userNameLabel.text = reviewsCell.name
        starsModule.rating = reviewsCell.rating
        productReviewTextLabel.text = reviewsCell.review
        model.getReviewImage(reviewId: reviewsCell.id) {[weak self] result in
            switch result {
            case .success(let img):
                self?.poductReviewImageView.image = img
            case .failure(let error):
                print("[DEBUG]: \(error)")
                self?.poductReviewImageView.image = UIImage(named: "emptyIcon")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userReviewImageView.pin
            .top()
            .left(21)
            .height(55)
            .width(55)
        
        userNameLabel.pin
            .after(of: userReviewImageView)
            .top()
            .marginLeft(21)
            .right(150)
            .sizeToFit(.width)
        
        starsModule.pin
            .top()
            .after(of: userNameLabel)
            .marginRight(21)
            .marginTop(5)
            .sizeToFit()
        
        separatorReview.pin
            .bottom()
            .height(1)
            .marginTop(15)
            .marginBottom(21)
            .horizontally(40)
            .hCenter()
        
        poductReviewImageView.pin
            .above(of: separatorReview)
            .marginBottom(4)
            .right(of: userReviewImageView)
            .marginLeft(31)
            .height(75)
            .width(75)
        
        productReviewTextLabel.pin
            .below(of: userNameLabel)
            .above(of: poductReviewImageView)
            .right(of: userReviewImageView)
            .marginTop(8)
            .marginBottom(8)
            .marginLeft(31)
            .right(21)
    }
}
