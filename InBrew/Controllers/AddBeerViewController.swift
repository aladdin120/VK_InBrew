//
//  AddBeerViewController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit
import PinLayout

final class AddBeerViewController: UIViewController {
    
    private let addImageButton = UIButton()
    private let addImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Add photo"
        label.font = UIFont(name: "Comfortaa-Bold", size: 18)
        label.textColor = .primary
        
        return label
    }()
    private let topGradientView = UIView()
    private let userImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.backgroundColor = .minorBackground
        
        return image
    }()
    private let separatorView1 = UIView()
    private let productDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Detail"
        label.font = UIFont(name: "Comfortaa-Bold", size: 22)
        
        return label
    }()
    private let deleteImageButton = UIButton()
    private let beerNameTextView = UITextView()
    private let beerCountryTextView = UITextView()
    private let beerSortTextView = UITextView()
    private let dollarLabel: UILabel = {
        let label = UILabel()
        label.text = "$"
        label.font = UIFont(name: "Comfortaa-Bold", size: 20)
        
        return label
    }()
    private let beerPriceTextView = UITextView()
    private let beerDescriptionTextView = UITextView()
    private let addBeerButton = UIButton()
    private let popupView = UIView()
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Your brew has been added!"
        label.textColor = .text
        label.font = UIFont(name: "Comfortaa-Bold", size: 18)
        
        return label
    }()
    private let successImage = UIImageView(image: UIImage(named: "successIcon"))
    
    private let model: ProductsManagerProtocol = ProductsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        [
         userImage,
         addImageLabel,
         dollarLabel,
         productDetailLabel
        ].forEach() { view.addSubview($0) }
        setupButtons()
        setupSeparators()
        setupTextViews()
        setupPopUpView()
        view.addSubview(popupView)
    }
    
    func setupPopUpView () {
        popupView.isHidden = true
        popupView.backgroundColor = .background
        popupView.layer.borderWidth = 2
        popupView.layer.borderColor = UIColor.primary.cgColor
        popupView.layer.cornerRadius = 25
        
        [successImage, successLabel].forEach() {
            popupView.addSubview($0)
        }
    }
    
    func setupSeparators() {
        separatorView1.backgroundColor = .separator
        view.addSubview(separatorView1)
    }
    
    func setupButtons() {
        let plusImage = UIImage(named: "addReviewIcon")
        addImageButton.setImage(plusImage, for: .normal)
        addImageButton.imageView?.contentMode = .scaleAspectFit
        addImageButton.addTarget(self, action: #selector(didTapAddPhotoButton), for: .touchUpInside)
        
        let removeImage = UIImage(systemName: "xmark.circle")
        deleteImageButton.imageView?.layer.transform = CATransform3DMakeScale(2.0, 2.0, 0)
        deleteImageButton.imageView?.contentMode = .scaleAspectFit
        deleteImageButton.imageView?.tintColor = .primary
        deleteImageButton.setImage(removeImage, for: .normal)
        deleteImageButton.addTarget(self, action: #selector(didTapDeleteImageButton), for: .touchUpInside)
        deleteImageButton.isHidden = true
        
        addBeerButton.backgroundColor = .primary
        addBeerButton.setTitle("Add new beer", for: .normal)
        addBeerButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 18)
        addBeerButton.titleLabel?.tintColor = .lightText
        addBeerButton.layer.cornerRadius = 19
        addBeerButton.addTarget(self, action: #selector(didTapAddBeerButton), for: .touchUpInside)
        
        [addImageButton,
         addBeerButton,
         deleteImageButton].forEach { view.addSubview($0) }
    }
    
    func setupTextViews() {
        beerNameTextView.text = "Name of brew"
        beerCountryTextView.text = "Country"
        beerDescriptionTextView.text = "Write a few words about this drink"
        beerSortTextView.text = "Sort"
        [beerNameTextView,
         beerDescriptionTextView,
         beerPriceTextView,
         beerCountryTextView,
         beerSortTextView
        ].forEach {
            $0.textColor = .text
            $0.font = UIFont(name: "Comfortaa-Light", size: 18)
            $0.textColor = UIColor.gray
            $0.translatesAutoresizingMaskIntoConstraints = true
            $0.accessibilityScroll(.down)
            $0.sizeToFit()
            $0.layer.borderWidth = 0.8
            $0.layer.cornerRadius = 4
            $0.layer.borderColor = UIColor.border.cgColor
            $0.delegate = self
            view.addSubview($0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        userImage.pin
            .top()
            .width(view.bounds.width)
            .height(view.bounds.height / 2.3)
            
        addImageButton.pin
            .vCenter(to: userImage.edge.vCenter)
            .hCenter(to: userImage.edge.hCenter)
            .marginTop(10)
            .width(100)
            .height(100)
        
        addImageLabel.pin
            .below(of: addImageButton)
            .hCenter(to: addImageButton.edge.hCenter)
            .sizeToFit()
        
        beerNameTextView.pin
            .below(of: userImage)
            .horizontally(10)
            .marginTop(25)
            .width(view.bounds.width - 20)
    
        beerCountryTextView.pin
            .below(of: beerNameTextView)
            .width(35%)
            .horizontally(10)
            .marginTop(18)
        
        beerSortTextView.pin
            .below(of: beerNameTextView)
            .after(of: beerCountryTextView)
            .before(of: dollarLabel)
            .width(35%)
            .marginLeft(10)
            .marginTop(18)
        
        beerPriceTextView.pin
            .below(of: beerNameTextView)
            .right(10)
            .width(15%)
            .marginTop(18)
        
        dollarLabel.pin
            .before(of: beerPriceTextView)
            .marginLeft(10)
            .sizeToFit()
            .vCenter(to: beerPriceTextView.edge.vCenter)
        
        separatorView1.pin
            .below(of: beerCountryTextView)
            .marginTop(15)
            .height(0.5)
            .horizontally(4)
        
        productDetailLabel.pin
            .below(of: separatorView1)
            .left(10)
            .marginTop(15)
            .sizeToFit()
        
        beerDescriptionTextView.pin
            .below(of: productDetailLabel)
            .marginTop(18)
            .horizontally(10)
            .height(13%)
        
        addBeerButton.pin
            .below(of: beerDescriptionTextView)
            .marginTop(15)
            .horizontally(5)
            .height(8%)
        
        deleteImageButton.pin
            .top(view.safeAreaInsets.top)
            .right(40)
            .height(40)
            .width(40)
        
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
        }) { [weak self] finished in
            if finished {
                self?.userImage.image = nil
                self?.addImageButton.isHidden = false
                self?.addImageLabel.isHidden = false
                self?.deleteImageButton.isHidden = true
            }
        }
    }
    
    @objc
    func didTapAddPhotoButton()  {
        self.showImagePickerControllerActionSheet()
    }
    
    @objc
    func didTapDeleteImageButton() {
        userImage.image = nil
        addImageButton.isHidden = false
        addImageLabel.isHidden = false
        deleteImageButton.isHidden = true
    }
    
    @objc
    func didTapAddBeerButton() {
        
        if beerSortTextView.text == "Sort" || beerSortTextView.text.isEmpty || beerNameTextView.text == "Name" || beerNameTextView.text.isEmpty || beerCountryTextView.text == "Name" || beerCountryTextView.text.isEmpty ||
            beerDescriptionTextView.text == "Write a few words about this drink" || beerDescriptionTextView.text.isEmpty || beerPriceTextView.text.isEmpty {
            successLabel.text = "Not all fields are entered"
            successImage.image = UIImage(systemName: "xmark.circle")
            successImage.tintColor = .red
            popupView.layer.borderColor = UIColor.red.cgColor
            popupView.isHidden = false
            fadeIn()
            
            return
        }
        
        let image = userImage.image?.jpegData(compressionQuality: 1.0)
        guard let beerName = beerNameTextView.text,
              let beerCountry = beerCountryTextView.text,
              let beerPrice = beerPriceTextView.text,
              let beerDescription = beerDescriptionTextView.text,
              let beerSort = beerSortTextView.text else {
            return
        }
        
        let data: [String: Any] = [
            "name": beerName,
            "country": beerCountry,
            "price": "$"+beerPrice,
            "description": beerDescription,
            "sort": beerSort
        ]
        
        model.addBeer(with: data, with: image) { [weak self] result in
            switch result {
            case .success(_):
                self?.popupView.isHidden = false
                self?.successLabel.text = "Your brew has been added!"
                self?.popupView.layer.borderColor = UIColor.primary.cgColor
                self?.successImage.image = UIImage(named: "successIcon")
                self?.successImage.tintColor = .primary
                self?.fadeIn()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AddBeerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            addImageButton.isHidden = true
            deleteImageButton.isHidden = false
            addImageLabel.isHidden = true
        } else if let originalImage  = info[.originalImage] as? UIImage {
            userImage.image = originalImage
            addImageButton.isHidden = true
            deleteImageButton.isHidden = false
            addImageLabel.isHidden = true
        }
    }
}

extension AddBeerViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            if textView == beerSortTextView {
                textView.text = "Sort"
            } else if textView == beerNameTextView {
                textView.text = "Name"
            } else if textView == beerCountryTextView {
                textView.text = "Country"
            } else if textView == beerDescriptionTextView {
                textView.text = "Write a few words about this drink"
            }
        }
    }
}
