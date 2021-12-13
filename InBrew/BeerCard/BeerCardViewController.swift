//
//  BeerCardViewController.swift
//  InBrew
//
//  Created by golub_dobra on 10.11.2021.
//

import UIKit
import PinLayout

final class BeerCardViewController: UIViewController {
//    private let maxRating = 5
    private let scrollView = UIScrollView()
    private let beerImageView = UIImageView()
    private let beerTitleLabel = UILabel()
    private let likeOfBeerButton = UIButton()
    private let beerContryLabel = UILabel()
    private let beerCostLabel = UILabel()
    private let costSeparator = UIView()
    private let beerDetailTitleLable = UILabel()
    private let beerDetailDescriptionLabel = UILabel()
    private let descriptionSeparator = UIView()
    private let showBeerReviewButton = UIButton()
    private let goToReviewScreenImage = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let addReviewButton = UIButton()
    private let databaseModel: DatabaseModel = DatabaseModel()
    private let starsModule = StarsModule(frame: CGRect(x: 0, y: 30, width: Int((5*starSize) + (4*starSpasing)), height: Int(starSize)))
    
    private let model: ImageLoaderProtocol = ImageLoader.shared
    var product: Product? {
        didSet {
            guard let product = product else {
                return
            }

            configure(with: product)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        scrollView.alwaysBounceVertical = true
        
        beerImageView.contentMode = .scaleAspectFit
        beerImageView.clipsToBounds = true
        beerImageView.alpha = 0.9
        beerImageView.layer.cornerRadius = 25
        beerImageView.layer.masksToBounds = true
        beerImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        beerTitleLabel.font = UIFont(name: "Comfortaa-Bold", size: 24)
        beerTitleLabel.textColor = .text
        beerTitleLabel.lineBreakMode = .byWordWrapping
        beerTitleLabel.numberOfLines = 0
        
        likeOfBeerButton.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 0)
        likeOfBeerButton.imageView?.contentMode = .scaleAspectFit
        likeOfBeerButton.tintColor = .primary
        likeOfBeerButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        beerContryLabel.font = UIFont(name: "Comfortaa-Bold", size: 16)
        beerContryLabel.textColor = .minorText
        
        beerCostLabel.font = UIFont(name: "Comfortaa-Bold", size: 24)
        beerCostLabel.textColor = .text
        
        [costSeparator,descriptionSeparator].forEach() {
            ($0).backgroundColor = .separator
        }
        beerDetailTitleLable.numberOfLines = 0
        beerDetailTitleLable.text = "Product Detail"
        beerDetailTitleLable.font = UIFont(name: "Comfortaa-Bold", size: 16)
        beerDetailTitleLable.textColor = .text
        
        beerDetailDescriptionLabel.font = UIFont(name: "Comfortaa-Bold", size: 13)
        beerDetailDescriptionLabel.textColor = .minorText
        beerDetailDescriptionLabel.lineBreakMode = .byWordWrapping
        beerDetailDescriptionLabel.numberOfLines = 0
        
        showBeerReviewButton.setTitle("Review", for: .normal)
        showBeerReviewButton.setTitleColor(.text, for: .normal)
        showBeerReviewButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 16)
        showBeerReviewButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 10, right: view.frame.width)
        showBeerReviewButton.addTarget(self, action: #selector(didTapShowReviewButton), for: .touchUpInside)
        
        goToReviewScreenImage.tintColor = .text
        
        addReviewButton.backgroundColor = .primary
        addReviewButton.setTitle("Write a review", for: .normal)
        addReviewButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 18)
        addReviewButton.titleLabel?.tintColor = .lightText
        addReviewButton.layer.cornerRadius = 19
        addReviewButton.addTarget(self, action: #selector(didTapWriteReviewButton), for: .touchUpInside)
        
        [beerImageView,
         beerTitleLabel,
         likeOfBeerButton,
         beerContryLabel,
         beerCostLabel,
         costSeparator,
         beerDetailTitleLable,
         beerDetailDescriptionLabel,
         descriptionSeparator,
         starsModule,
         goToReviewScreenImage,
         showBeerReviewButton,
         addReviewButton].forEach() {
            scrollView.addSubview($0)
        }
        view.addSubview(scrollView)
    }
    
    func configure(with product: Product) {
        beerTitleLabel.text = product.name
        beerContryLabel.text = product.categories + ", " + product.sort
        beerCostLabel.text = product.price
        beerDetailDescriptionLabel.text = product.description
        if product.isFavourite {
            likeOfBeerButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeOfBeerButton.restorationIdentifier = "heart.fill"
        } else {
            likeOfBeerButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeOfBeerButton.restorationIdentifier = "heart"
        }
        
        model.getBeerImage(beerId: product.id) { [weak self] result in
            switch result {
            case .success(let img):
                self?.beerImageView.image = img
            case .failure(let error):
                print("[DEBUG]: \(error)")
                self?.beerImageView.image = UIImage(named: "defaultIcon")
            }
        }
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
        
        scrollView.pin.all()
        
        beerImageView.pin
            .top(-(navigationController?.navigationBar.frame.height  ?? 0))// - view.pin.safeArea.top)
            .width(view.bounds.width)
            .height(view.bounds.width)
        
       
        likeOfBeerButton.pin
            .below(of: beerImageView)
            .marginTop(18)
            .right(19)
            .height(26)
            .width(31)
        
        beerTitleLabel.pin
            .below(of: beerImageView)
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
            .right(23)
            .sizeToFit()
        
        costSeparator.pin
            .below(of: beerCostLabel)
            .marginTop(11)
            .horizontally(6)
            .height(0.1)
        
        beerDetailTitleLable.pin
            .below(of: costSeparator)
            .marginTop(17)
            .horizontally(21)
            .sizeToFit(.width)
        
        beerDetailDescriptionLabel.pin
            .below(of: beerDetailTitleLable)
            .horizontally(21)
            .marginTop(8)
            .sizeToFit(.width)
        
        descriptionSeparator.pin
            .below(of: beerDetailDescriptionLabel)
            .marginTop(12)
            .horizontally(6)
            .height(0.1)
        
        goToReviewScreenImage.pin
            .below(of: descriptionSeparator)
            .right(23)
            .marginTop(22)
            .sizeToFit()
        
        starsModule.pin
            .below(of: descriptionSeparator)
            .before(of: goToReviewScreenImage)
            .marginRight(17)
            .marginTop(20)
            .sizeToFit()
        
        showBeerReviewButton.pin
            .below(of: descriptionSeparator)
            .before(of: goToReviewScreenImage)
            .marginTop(20)
            .left()
            .sizeToFit()
        
        addReviewButton.pin
            .below(of: showBeerReviewButton)
            .marginTop(28)
            .horizontally(5)
            .height(67)
        
        scrollView.contentSize = CGSize(width: view.bounds.width, height: addReviewButton.frame.maxY + 25)
        
    }
    
    @objc
    func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapShowReviewButton() {
        guard let product = product else {
            return
        }
        
        let reviewsViewController = ReviewsViewController()
        reviewsViewController.product = product
        let navigationController = UINavigationController(rootViewController: reviewsViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    func didTapWriteReviewButton() {
        guard let product = product else {
            return
        }
        
        let addReviewViewController = AddReviewViewController()
        addReviewViewController.product = product
        let navigationController = UINavigationController(rootViewController: addReviewViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    func didTapLikeButton() {
        guard let productId = product?.id else {
            print("[DEBUG]: Not find product id!")
            return
        }
        
        if likeOfBeerButton.restorationIdentifier == "heart" {
            likeOfBeerButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeOfBeerButton.restorationIdentifier = "heart.fill"
            
            databaseModel.addFavouriteBeerInDatabase(beerId: productId) {  document in
                switch document {
                case .success(_):
                    print("[DEBUG]: Yes!")
                    
                case .failure(_):
                    print("[DEBUG]: \(FirebaseError.emptyDocumentData)")
                }
            }
            
        } else if likeOfBeerButton.restorationIdentifier == "heart.fill" {
            likeOfBeerButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeOfBeerButton.restorationIdentifier = "heart"
            
            databaseModel.removeFavouriteBeerFromDatabase(beerId: productId) { document in
                switch document {
                case .success(_):
                    print("[DEBUG]: Yes!")
                 
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
}
