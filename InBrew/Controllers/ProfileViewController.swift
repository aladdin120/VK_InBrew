//
//  ProfileViewController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit
import PinLayout

final class ProfileViewController: UIViewController {
    private var ligout: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .fail
        button.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(ligout)
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ligout.pin
            .center()
            .sizeToFit()
    }
 
    @objc
    func didTapLogOutButton() {
        UserDefaults.standard.setValue(false, forKey: "isAuth")
        let authViewController = AuthViewController()
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: false, completion: nil)
    }
}

