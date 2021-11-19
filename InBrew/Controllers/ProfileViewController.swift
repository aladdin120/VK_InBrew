//
//  ProfileViewController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit
import Firebase

final class ProfileViewController: UIViewController {
    private let profileView = ProfileView(frame: .init())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        profileView.delegate = self
        view.addSubview(profileView)
        profileView.frame = view.frame
    }
    
}

extension ProfileViewController: ProfileViewDelegate {
    func logOutTapButton() {
        
        print("hello logout")
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func editTapButton() {
        print("hello, editButton")
    }
    
    func estimationTapButton() {
        print("hello, estimationTabButton")
    }
    
    func aboutTapButton() {
        print("hello, aboutTapButton")
    }
    
}

protocol ProfileViewDelegate: AnyObject {
    func editTapButton()
    func estimationTapButton()
    func aboutTapButton()
    func logOutTapButton()
}

class ProfileView: UIView {
    private let editButton = UIButton()
    private let estimationButton = UIButton()
    private let aboutButton = UIButton()
    private let logOutButton = UIButton()

    private let profileImageView = UIImageView(image: UIImage(named: "defaultProfileImage"))
    
    weak var delegate: ProfileViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        editButton.setImage(UIImage(systemName: "gear"), for: .normal)
        editButton.tintColor = UIColor.black

        estimationButton.setTitle("My estimations" , for: .normal)
        estimationButton.backgroundColor = UIColor.systemGray
        estimationButton.layer.cornerRadius = 8
        estimationButton.contentHorizontalAlignment = .left

        aboutButton.setTitle("About", for: .normal)
        aboutButton.backgroundColor = UIColor.systemGray
        aboutButton.layer.cornerRadius = 8
        aboutButton.contentHorizontalAlignment = .left

        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.backgroundColor = UIColor.systemGray
        logOutButton.layer.cornerRadius = 8

        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        addSubview(editButton) //? view.addSubview(editButton)
        addSubview(estimationButton)
        addSubview(aboutButton)
        addSubview(logOutButton)
        addSubview(profileImageView)

        editButton.addTarget(self, action: #selector(editTapButton), for: .touchUpInside)
        estimationButton.addTarget(self, action: #selector(estimationTapButton), for: .touchUpInside)
        aboutButton.addTarget(self, action: #selector(aboutTapButton), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutTapButton), for: .touchUpInside)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()

        editButton.frame = CGRect(x: 340, y: 15, width: 100, height: 100)
        
        estimationButton.frame = CGRect(x: self.frame.maxX/16, y: center.y, width: 150, height: 50)
        
        aboutButton.frame = CGRect(x: estimationButton.frame.minX, y: estimationButton.frame.maxY+10, width: 150, height: 50)
        
        logOutButton.frame = CGRect(x: center.x-logOutButton.frame.width/2, y: self.frame.maxY*5/6, width: 150, height: 50)
        
        profileImageView.frame = CGRect(x: center.x-profileImageView.frame.width/2, y: 0, width: 100, height: 100)
        profileImageView.center.y = editButton.center.y+20
    }
    
    
    @objc func editTapButton() {
        delegate?.editTapButton()
    }

    @objc func estimationTapButton() {
        delegate?.estimationTapButton()
    }

    @objc func aboutTapButton() {
        delegate?.aboutTapButton()
    }
    
    @objc func logOutTapButton() {
        delegate?.logOutTapButton()
    }
}
