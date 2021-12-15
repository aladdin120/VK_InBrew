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
    private let username = UILabel()
        
    private let profileImageView = UIImageView(image: UIImage(named: "defaultProfileImage"))
    
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
        
        setUpUserEmail()
        setUpUserName()
        
        username.font = UIFont(name: "Comfortaa-Bold", size: 12)
        
        view.addSubview(editButton)
//        view.addSubview(estimationButton)
        view.addSubview(aboutButton)
        view.addSubview(logOutButton)
        view.addSubview(profileImageView)
        view.addSubview(userData)
        view.addSubview(username)
        
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

        aboutButton.pin
            .below(of: editButton)
            .marginTop(13)
            .width(160)
            .height(60)
            .left(10)


//        estimationButton.pin
//            .below(of: estimationButton)
//            .marginTop(13)
//            .width(160)
//            .height(60)
//            .left(10)

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
        
        username.pin
            .topCenter(60 + userData.frame.width)
//            .marginTop(6)
            .width(160)
            .height(50)
    }
    
    func setUpUserEmail () {
        
        getUserEmail() { [weak self] result in
            
            switch result {
            case .success(let userEmail):
                self?.userData.text = userEmail
                
            case .failure(_):
                return
            }
        }
    }
    
    func setUpUserName () {
        
        getUserName() { [weak self] result in
            
            switch result {
            case .success(let username):
                self?.username.text = username
                
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
        let alert = UIAlertController(title: "Dear user", message: "We hope that you enjoy InBrew app", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "I am happy", style: .cancel, handler: { (action) in }))
        self.present(alert, animated: true, completion: nil)
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
    
    
    func getUserEmail(completion: @escaping (Result<String, Error>) -> Void) {
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

    
    func getUserName(completion: @escaping (Result<String, Error>) -> Void) {
        let database = Firestore.firestore().collection("users")
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        database.document(currentUser.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let name = document.get("name") as? String ?? ""
                completion(.success("Hello " + name))
            } else {
                completion(.failure(error ?? FirebaseError.notFindUser))

            }

        }

    }
    
}
