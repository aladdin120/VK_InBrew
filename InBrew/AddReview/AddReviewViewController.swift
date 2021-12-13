//
//  AddReviewViewController.swift
//  InBrew
//
//  Created by golub_dobra on 29.11.2021.
//

import UIKit
import PinLayout

final class AddReviewViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let addImageButton = UIButton()
    private let deleteImageButton = UIButton()
    private let topGradientView = UIView()
    private let userImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        
        return image
    }()
    
    private let beerDescriptionLabel = UILabel()
    private let beerDescriptionTextView = UITextView()
    private let ratingLabel = UILabel()
    private let starsModule = StarsModule(frame: CGRect(x: 0, y: 30, width: Int((5*starSize) + (4*starSpasing)), height: Int(starSize)))
    private let sendReviewButton = UIButton()
    private let popupView = UIView()
    private let successLabel = UILabel()
    private let successImage = UIImageView(image: UIImage(named: "successIcon"))
    
    private let databaseModel: DatabaseModel = DatabaseModel()
    
    var product: Product? {
        didSet {
            guard let product = product else {
                return
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .background
        
        let plusImage = UIImage(named: "addReviewIcon")
        addImageButton.setImage(plusImage, for: .normal)
        addImageButton.imageView?.contentMode = .scaleAspectFit
        addImageButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 80.0, bottom: 0.0, right: 0.0)
        addImageButton.setTitle("Add photo", for: .normal)
        addImageButton.setTitleColor(.primary, for: .normal)
        addImageButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 18)
        addImageButton.titleEdgeInsets = UIEdgeInsets(top: 130.0, left: 0.0, bottom: 0.0, right: 100.0)
        addImageButton.backgroundColor = .minorBackground
        addImageButton.layer.cornerRadius = 25
        addImageButton.layer.masksToBounds = true
        addImageButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        addImageButton.addTarget(self, action: #selector(didTapAddPhotoButton), for: .touchUpInside)
        
        let removeImage = UIImage(systemName: "xmark.circle")
        deleteImageButton.imageView?.layer.transform = CATransform3DMakeScale(2.0, 2.0, 0)
        deleteImageButton.imageView?.contentMode = .scaleAspectFit
        deleteImageButton.imageView?.tintColor = .primary
        deleteImageButton.setImage(removeImage, for: .normal)
        deleteImageButton.addTarget(self, action: #selector(didTapDeleteImageButton), for: .touchUpInside)
        deleteImageButton.isHidden = true
        
        userImage.isHidden = true
        
        beerDescriptionLabel.text = "Review"
        beerDescriptionLabel.textColor = .text
        
        beerDescriptionTextView.text = "Write a few words about this beer"
        beerDescriptionTextView.textColor = .text
        beerDescriptionTextView.font = UIFont(name: "Comfortaa-Bold", size: 14)
        beerDescriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        beerDescriptionTextView.accessibilityScroll(.down)
        beerDescriptionTextView.sizeToFit()
        beerDescriptionTextView.layer.borderWidth = 0.8
        beerDescriptionTextView.layer.cornerRadius = 10
        beerDescriptionTextView.layer.borderColor = UIColor.border.cgColor
        
        
        ratingLabel.text = "Rating"
        
        [beerDescriptionLabel,
         ratingLabel].forEach() {
            ($0).font = UIFont(name: "Comfortaa-Bold", size: 18)
         }
        
        sendReviewButton.isUserInteractionEnabled = true
        sendReviewButton.backgroundColor = .primary
        sendReviewButton.setTitle("Send a review", for: .normal)
        sendReviewButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 18)
        sendReviewButton.titleLabel?.tintColor = .lightText
        sendReviewButton.layer.cornerRadius = 19
        sendReviewButton.addTarget(self, action: #selector(didTapSendReviewButton), for: .touchUpInside)
        
        popupView.isHidden = true
        popupView.backgroundColor = .background
        popupView.layer.borderWidth = 2
        popupView.layer.borderColor = UIColor.primary.cgColor
        popupView.layer.cornerRadius = 25
        
        successLabel.text = "Thank you for your review!"
        successLabel.textColor = .text
        successLabel.font = UIFont(name: "Comfortaa-Bold", size: 18)
        
        [successImage, successLabel].forEach() {
            popupView.addSubview($0)
        }
        
        [userImage,
         topGradientView,
         addImageButton,
         deleteImageButton,
         beerDescriptionLabel,
         beerDescriptionTextView,
         ratingLabel,
         starsModule,
         sendReviewButton,
         popupView].forEach() {
            scrollView.addSubview($0)
         }
        view.addSubview(scrollView)
    }
    
    func addGradient()  {
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor.minorBackground.withAlphaComponent(1.0).cgColor
        let middleColor = UIColor.minorBackground.withAlphaComponent(0.9).cgColor
        let bottomColor = UIColor.minorBackground.withAlphaComponent(0.0).cgColor
        gradientLayer.colors = [topColor, middleColor, bottomColor]
        gradientLayer.locations = [0.0, 0.2, 1.0]
        gradientLayer.frame = topGradientView.frame
        topGradientView.layer.addSublayer(gradientLayer)
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
        scrollView.pin.all()
        addImageButton.pin
            .top(-(navigationController?.navigationBar.frame.height  ?? 0) - view.pin.safeArea.top)
            .width(view.bounds.width)
            .height(view.bounds.width + view.pin.safeArea.top)
        
        userImage.pin
            .top(-(navigationController?.navigationBar.frame.height  ?? 0))
            .width(view.bounds.width)
            .height(view.bounds.width)
        
        topGradientView.pin
            .top(-(navigationController?.navigationBar.frame.height  ?? 0) - view.pin.safeArea.top)
            .width(view.bounds.width)
            .height(view.bounds.width + view.pin.safeArea.top)
        
        deleteImageButton.pin
            .top()
            .right(20)
            .sizeToFit()
        
        beerDescriptionLabel.pin
            .below(of: topGradientView)
            .marginTop(18)
            .left(21)
            .sizeToFit()
        
        beerDescriptionTextView.pin
            .below(of: beerDescriptionLabel)
            .marginTop(10)
            .horizontally(21)
            .height(150)
        
        ratingLabel.pin
            .below(of: beerDescriptionTextView)
            .marginTop(18)
            .left(21)
            .sizeToFit()
        
        starsModule.pin
            .below(of: ratingLabel)
            .marginTop(10)
            .left(21)
            .sizeToFit()
        
        sendReviewButton.pin
            .below(of: starsModule)
            .marginTop(28)
            .horizontally(5)
            .height(67)
            .bottom(25)
        
        popupView.pin
            .horizontally(30)
            .height(200)
            .top(20%)
        
        successImage.pin
            .top(20)
            .hCenter()
            .sizeToFit()
        
        successLabel.pin
            .below(of: successImage)
            .marginTop(10)
            .hCenter()
            .sizeToFit()
        
        addGradient()
        
        scrollView.contentSize = CGSize(width: view.bounds.width, height: sendReviewButton.frame.maxY + 25)
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
            self.popupView.alpha = 1.0
        }) { finished in
            if finished {
                self.fadeOut()
            }
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveLinear, animations: {
            self.popupView.alpha = 0.0
        }) { finished in
            if finished {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc
    func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapAddPhotoButton()  {
        showImagePickerControllerActionSheet()
    }
    
    @objc
    func didTapDeleteImageButton() {
        userImage.image = nil
        addImageButton.isHidden = false
        deleteImageButton.isHidden = true
    }
    
    @objc
    func didTapSendReviewButton() {
        let image = userImage.image?.jpegData(compressionQuality: 1.0)
        
        guard let beerId = product?.id,
              let userReview = beerDescriptionTextView.text else {
            return
        }
        
        
        databaseModel.postBeerReviewInDatabase(beerId: beerId, image: image, review: userReview, rating: starsModule.rating) {[weak self] result in
            switch result {
            case .success(_):
                [self?.sendReviewButton,
                 self?.addImageButton,
                 self?.starsModule,
                 self?.beerDescriptionTextView].forEach() {
                    ($0)?.isUserInteractionEnabled = false
                 }
                self?.popupView.isHidden = false
                self?.fadeIn()
                
            case .failure(_):
                return
            }
        }
        
    }
}

extension AddReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerActionSheet() {
        let alert = UIAlertController(title: "Select image", message: "From one of the options", preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) {[weak self] action in
            self?.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) {[weak self] action in
            self?.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [photoLibraryAction,
         cameraAction,
         cancelAction].forEach() {
            alert.addAction($0)
         }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle = .fullScreen
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let editedImage  = info[.editedImage] as? UIImage {
            userImage.image = editedImage
            userImage.isHidden = false
            addImageButton.isHidden = true
            deleteImageButton.isHidden = false
        } else if let originalImage  = info[.originalImage] as? UIImage {
            userImage.image = originalImage
            userImage.isHidden = false
            addImageButton.isHidden = true
            deleteImageButton.isHidden = false
        }
    }
}
