//  ProfileViewController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit
import Firebase
import PinLayout
import SwiftUI
import FirebaseAuth

final class ProfileViewController: UIViewController {
    private let editButton = UIButton()
    private let estimationButton = UIButton()
    private let aboutButton = UIButton()
    private let logOutButton = UIButton()
    
    private let userData = UILabel()
        
    private let profileImageView = UIImageView(image: UIImage(named: "AppIcon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        
        editButton.setTitle("Edit profile", for: .normal)
        editButton.contentHorizontalAlignment = .left
        editButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 17)
        editButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        editButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        editButton.layer.cornerRadius = 8
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.systemYellow.cgColor
        editButton.setTitleColor(.black, for: .normal)
        
        estimationButton.setTitle("My estimations" , for: .normal)
        estimationButton.contentHorizontalAlignment = .left
        estimationButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 17)
        estimationButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        estimationButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        estimationButton.layer.cornerRadius = 8
        estimationButton.layer.borderWidth = 1
        estimationButton.layer.borderColor = UIColor.systemYellow.cgColor
        estimationButton.setTitleColor(.black, for: .normal)
        
        aboutButton.setTitle("About", for: .normal)
        aboutButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        aboutButton.contentHorizontalAlignment = .left
        aboutButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 17)
        aboutButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        aboutButton.layer.cornerRadius = 8
        aboutButton.layer.borderWidth = 1
        aboutButton.layer.borderColor = UIColor.systemYellow.cgColor
        aboutButton.setTitleColor(.black, for: .normal)
        
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        logOutButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 17)
        logOutButton.layer.cornerRadius = 8
        logOutButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = UIColor.systemYellow.cgColor
        logOutButton.setTitleColor(.black, for: .normal)
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        setUpUserName()
        
        view.addSubview(editButton)
        view.addSubview(estimationButton)
        view.addSubview(aboutButton)
        view.addSubview(logOutButton)
        view.addSubview(profileImageView)
        view.addSubview(userData)
        
        editButton.addTarget(self, action: #selector(editTapButton), for: .touchUpInside)
        estimationButton.addTarget(self, action: #selector(estimationTapButton), for: .touchUpInside)
        aboutButton.addTarget(self, action: #selector(aboutTapButton), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutTapButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        editButton.pin
            .height(60)
            .width(160)
            .centerLeft(10)

        estimationButton.pin
            .below(of: editButton)
            .marginTop(13)
            .width(160)
            .height(60)
            .left(10)


        aboutButton.pin
            .below(of: estimationButton)
            .marginTop(13)
            .width(160)
            .height(60)
            .left(10)

        logOutButton.pin
            .width(100)
            .height(50)
            .bottomCenter(100)

        profileImageView.pin
            .width(100)
            .height(100)
            .topCenter(100)

        userData.pin
            .topCenter(100 + profileImageView.frame.width)
            .marginTop(13)
            .width(180)
            .height(50)
    }
    
    func setUpUserName () {
        
        getUserName() { [weak self] result in
            
            switch result {
            case .success(let userEmail):
                self?.userData.text = userEmail
                
            case .failure(_):
                return
            }
        }
    }
    
    
    @objc func editTapButton() {
        let editProfileViewController = UINavigationController(rootViewController: EditProfileViewController())
        editProfileViewController.modalPresentationStyle = .fullScreen
        self.present(editProfileViewController, animated: true, completion: nil)
        
    }
    
    @objc func estimationTapButton() {
        print("hello, estimateButton")
    }
    
    @objc func aboutTapButton() {
        print("hello, aboutButton")
    }
    
    @objc func logOutTapButton() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let authViewController = AuthViewController()
            authViewController.modalPresentationStyle = .fullScreen
            
            self.present(authViewController, animated: false, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    func getUserName(completion: @escaping (Result<String, Error>) -> Void) {
        let database = Firestore.firestore().collection("users")
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        database.document(currentUser.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let email = document.get("email") as? String ?? ""
                completion(.success(email))
            } else {
                completion(.failure(error ?? FirebaseError.notFindUser))
                
            }
            
        }
        
    }
    
}

//        editButton.frame = CGRect(x: view.frame.maxX-70, y: 15, width: 100, height: 100)
//
//        estimationButton.frame = CGRect(x: self.view.frame.maxX/16, y: view.center.y, width: 150, height: 50)
//
//        aboutButton.frame = CGRect(x: estimationButton.frame.minX, y: estimationButton.frame.maxY+10, width: 150, height: 50)
//
//        logOutButton.frame = CGRect(x: profileImageView.center.x, y: self.view.frame.maxY*5/6, width: 150, height: 50)
////
//        profileImageView.frame = CGRect(x: view.center.x-profileImageView.frame.width/2, y: 0, width: 100, height: 100)
////
//        profileImageView.center.y = editButton.center.y+30
////
//        userData.frame = CGRect(x:profileImageView.center.x, y:profileImageView.center.y+30, width: 170, height: 100)

//=======
//
//final class ProfileViewController: UIViewController {
//    private let profileView = ProfileView(frame: .init())
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        profileView.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
//        profileView.delegate = self
//        view.addSubview(profileView)
//        profileView.frame = view.frame
//    }
//
//}
//
//extension ProfileViewController: ProfileViewDelegate {
//    func logOutTapButton() {
//
//        print("hello logout")
//
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//            self.dismiss(animated: true, completion: nil)
//        } catch let signOutError as NSError {
//          print("Error signing out: %@", signOutError)
//        }
//    }
//
//    func editTapButton() {
//        print("hello, editButton")
//    }
//
//    func estimationTapButton() {
//        print("hello, estimationTabButton")
//    }
//
//    func aboutTapButton() {
//        print("hello, aboutTapButton")
//    }
//
//}
//
//protocol ProfileViewDelegate: AnyObject {
//    func editTapButton()
//    func estimationTapButton()
//    func aboutTapButton()
//    func logOutTapButton()
//}
//
//class ProfileView: UIView {
//    private let editButton = UIButton()
//    private let estimationButton = UIButton()
//    private let aboutButton = UIButton()
//    private let logOutButton = UIButton()
//
//    private let profileImageView = UIImageView(image: UIImage(named: "defaultProfileImage"))
//
//    weak var delegate: ProfileViewDelegate?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        editButton.setImage(UIImage(systemName: "gear"), for: .normal)
//        editButton.tintColor = UIColor.black
//
//        estimationButton.setTitle("My estimations" , for: .normal)
//        estimationButton.backgroundColor = UIColor.systemGray
//        estimationButton.layer.cornerRadius = 8
//        estimationButton.contentHorizontalAlignment = .left
//
//        aboutButton.setTitle("About", for: .normal)
//        aboutButton.backgroundColor = UIColor.systemGray
//        aboutButton.layer.cornerRadius = 8
//        aboutButton.contentHorizontalAlignment = .left
//
//        logOutButton.setTitle("Log out", for: .normal)
//        logOutButton.backgroundColor = UIColor.systemGray
//        logOutButton.layer.cornerRadius = 8
//
//        profileImageView.layer.cornerRadius = 40
//        profileImageView.clipsToBounds = true
//
//        addSubview(editButton) //? view.addSubview(editButton)
//        addSubview(estimationButton)
//        addSubview(aboutButton)
//        addSubview(logOutButton)
//        addSubview(profileImageView)
//
//        editButton.addTarget(self, action: #selector(editTapButton), for: .touchUpInside)
//        estimationButton.addTarget(self, action: #selector(estimationTapButton), for: .touchUpInside)
//        aboutButton.addTarget(self, action: #selector(aboutTapButton), for: .touchUpInside)
//        logOutButton.addTarget(self, action: #selector(logOutTapButton), for: .touchUpInside)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//
//        super.layoutSubviews()
//
//        editButton.frame = CGRect(x: 340, y: 15, width: 100, height: 100)
//
//        estimationButton.frame = CGRect(x: self.frame.maxX/16, y: center.y, width: 150, height: 50)
//
//        aboutButton.frame = CGRect(x: estimationButton.frame.minX, y: estimationButton.frame.maxY+10, width: 150, height: 50)
//
//        logOutButton.frame = CGRect(x: center.x-logOutButton.frame.width/2, y: self.frame.maxY*5/6, width: 150, height: 50)
//
//        profileImageView.frame = CGRect(x: center.x-profileImageView.frame.width/2, y: 0, width: 100, height: 100)
//        profileImageView.center.y = editButton.center.y+20
//    }
//
//
//    @objc func editTapButton() {
//        delegate?.editTapButton()
//    }
//
//    @objc func estimationTapButton() {
//        delegate?.estimationTapButton()
//    }
//
//    @objc func aboutTapButton() {
//        delegate?.aboutTapButton()
//    }
//
//    @objc func logOutTapButton() {
//        delegate?.logOutTapButton()
//    }
//}
//>>>>>>> 05bf5573665f3c97fc2adc02721509fff1496f94

