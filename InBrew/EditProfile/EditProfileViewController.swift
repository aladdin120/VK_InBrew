//
//  EditProfileViewController.swift
//  InBrew
//
//  Created by Арсен on 01.12.2021.
//

import UIKit
import PinLayout
import Firebase
import FirebaseDatabase

final class EditProfileViewController: UIViewController{
//    private let newUsernameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300.0, height: 30.0))
//    private let newPasswordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300.0, height: 30.0))
//    private let confirmNewPasswordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300.0, height: 30.0))
    
    private let editLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    private let editStatusLabel = UILabel()
    
    private let saveChangesButton = UIButton()
    private let newProfileImageButton = UIButton()
    
    private let newUsernameTextField = UITextField()
    private let newPasswordTextField = UITextField()
    private let confirmNewPasswordTextField = UITextField()
    
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        editLabel.text = "Edit profile"
        editLabel.font = UIFont(name: "Comfortaa-Bold", size: 25 )
        editLabel.textColor = .minorText
        
        saveChangesButton.setTitle("Save changes", for: .normal)
        saveChangesButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        saveChangesButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 17)
        saveChangesButton.layer.cornerRadius = 8
        saveChangesButton.layer.borderWidth = 1
        saveChangesButton.layer.borderColor = UIColor.systemYellow.cgColor
        saveChangesButton.setTitleColor(.black, for: .normal)
        saveChangesButton.addTarget(self, action: #selector(saveTapButton), for: .touchUpInside)
        
        newProfileImageButton.setTitle("Set new profile image", for: .normal)
        newProfileImageButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        newProfileImageButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 17)
        newProfileImageButton.layer.cornerRadius = 8
        newProfileImageButton.layer.borderWidth = 1
        newProfileImageButton.layer.borderColor = UIColor.systemYellow.cgColor
        newProfileImageButton.setTitleColor(.black, for: .normal)
        newProfileImageButton.addTarget(self, action: #selector(didTapSetImageButton), for: .touchUpInside)
        
        newUsernameTextField.placeholder = "New username"
        newUsernameTextField.keyboardAppearance = .light
        
        newPasswordTextField.placeholder = "New password"
        newPasswordTextField.isSecureTextEntry = true
        
        confirmNewPasswordTextField.placeholder = "Confirm your new password"
        confirmNewPasswordTextField.isSecureTextEntry = true
        
        [newUsernameTextField,
         newPasswordTextField,
         confirmNewPasswordTextField].forEach() {
            ($0).font = UIFont(name: "Comfortaa-Bold", size: 15)
            ($0).borderStyle = .none
            ($0).textColor = .text
         }
        
        view.addSubview(editLabel)
        view.addSubview(newUsernameTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(confirmNewPasswordTextField)
        view.addSubview(saveChangesButton)
        view.addSubview(newProfileImageButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
               
        newUsernameTextField.pin
            .height(50)
            .width(300)
            .centerLeft(13)

        newPasswordTextField.pin
            .below(of: newUsernameTextField)
            .marginTop(13)
            .height(50)
            .width(300)
            .left(13)

        confirmNewPasswordTextField.pin
            .below(of: newPasswordTextField)
            .marginTop(13)
            .height(50)
            .width(300)
            .left(13)
        
        newProfileImageButton.pin
            .above(of: newUsernameTextField)
            .marginBottom(13)
            .width(300)
            .height(50)
            .left(13)
        
        editLabel.pin
            .above(of: newProfileImageButton)
            .marginBottom(13)
            .width(300)
            .height(50)
            .left(13)
        
        saveChangesButton.pin
            .width(140)
            .height(50)
            .bottomCenter(100)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let backButtonImage = UIImage(systemName: "chevron.backward")
        let backButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButtonItem
        navigationController?.navigationBar.tintColor = .primary
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func saveTapButton() {
        guard let newUsername = newUsernameTextField.text,
              let newPassword = newPasswordTextField.text,
              let confirmNewPassword = confirmNewPasswordTextField.text,
              !newUsername.isEmpty,
              !newPassword.isEmpty,
              !confirmNewPassword.isEmpty,
               newPassword == confirmNewPassword else {
                   let alert = UIAlertController(title: "Edit error", message: "Empty fields or password mismatch", preferredStyle: UIAlertController.Style.alert)
                   print("Can not save changes")
                   alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { (action) in }))
                   self.present(alert, animated: true, completion: nil)
                   return
              }
        
        
        let database = Firestore.firestore().collection("users")
        guard let currentUser = Auth.auth().currentUser else {
            return
        }

        database.document(currentUser.uid).updateData(["name": newUsername])
        Auth.auth().currentUser?.updatePassword(to: newPassword)
        
//        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
//        profileViewController.modalPresentationStyle = .fullScreen
//        self.present(profileViewController, animated: true, completion: nil)
        
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)

                
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func didTapSetImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
}


extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("WE GOT HEREEEEE")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            print(type(of: imageView))
        }
        
        let newImage = imageView.image?.jpegData(compressionQuality: 1.0)
        updateProfileImage(with: newImage) { result in
            switch result {
            case .success(_):
                print("Image saved")
            case .failure(_):
                print("It didn't work")
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateProfileImage(with image: Data?, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let reference = Storage.storage().reference()
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let storageRef = reference.child("users/" + currentUser.uid + ".jpeg")
        
        if (image != nil) {
            guard let image = image else {
                return
            }
            storageRef.putData(image, metadata: nil) { (metadata, error) in
                guard let _ = metadata,
                      error == nil else {
                          completion(.failure(FirebaseError.canNotAddDocument))
                          return
                }
            }
        }
        
        completion(.success(true))
    }
}
