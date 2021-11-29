//
//  AuthViewController.swift
//  InBrew
//
//  Created by golub_dobra on 28.10.2021.
//

import UIKit
import PinLayout

final class AuthViewController: UIViewController {
    private let logoImageView = UIImageView(image: UIImage(named: "logoIcon.png"))
    private let loginHeader = UILabel()
    private let loginDescription = UILabel()
    private let emailLabel = UILabel()
    private let passwordLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let emailSeparator = UIView()
    private let passwordSeparator = UIView()
    private let logInButton = UIButton()
    private let notRegisteredLabel = UILabel()
    private let signUpButton  = UIButton()
    private let authModel: AuthFirebaseModel = AuthFirebaseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        
        loginHeader.text = "LogIn"
        [loginHeader,
         notRegisteredLabel].forEach() {
            ($0).textColor = .text
         }
        
        loginHeader.font = UIFont(name: "Comfortaa-Bold", size: 26)
        
        loginDescription.text = "Enter your email and password"
        
        [loginDescription,
         emailLabel,
         passwordLabel].forEach() {
            ($0).textColor = .minorText
            ($0).font = UIFont(name: "Comfortaa-Bold", size: 16)
         }
        
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
        [emailLabel,
         passwordLabel].forEach() {
            ($0).font = UIFont(name: "Comfortaa-Bold", size: 16)
         }
        
        [emailSeparator,
         passwordSeparator].forEach() {
            ($0).backgroundColor = .separator
         }
        
        [emailTextField,
         passwordTextField].forEach() {
            ($0).font = UIFont(name: "Comfortaa-Bold", size: 15)
            ($0).borderStyle = .none
         }
        
//        let emailText = UserDefaults.standard.string(forKey: "isAuth")
//        emailTextField.text = emailText
        emailTextField.autocapitalizationType = .none
        
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        logInButton.backgroundColor = .primary
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.lightText, for: .normal)
        logInButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 18)
        logInButton.layer.cornerRadius = 19
        logInButton.addTarget(self, action: #selector(didTaplogInButton), for: .touchUpInside)
        
        notRegisteredLabel.text = "Don’t have an account?"
        notRegisteredLabel.font = UIFont(name: "Comfortaa-Bold", size: 14)
        notRegisteredLabel.textAlignment = .center
        
        signUpButton.setTitle("SignUp", for: .normal)
        signUpButton.setTitleColor(.primary, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 14)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        [logoImageView,
         loginHeader,
         loginDescription,
         emailLabel,
         passwordLabel,
         emailTextField,
         emailSeparator,
         passwordTextField,
         passwordSeparator,
         logInButton,
         notRegisteredLabel,
         signUpButton].forEach() {
            view.addSubview($0)
         }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoImageView.pin
            .top(view.pin.safeArea + 11)
            .height(110)
            .width(90)
            .hCenter()
        
        loginHeader.pin
            .below(of: logoImageView)
            .left(25)
            .marginTop(44)
            .sizeToFit()
        
        loginDescription.pin
            .below(of: loginHeader)
            .left(25)
            .marginTop(15)
            .sizeToFit()
        
        emailLabel.pin
            .below(of: loginDescription)
            .left(25)
            .marginTop(43)
            .sizeToFit()
        
        emailTextField.pin
            .below(of: emailLabel)
            .marginTop(10)
            .height(50)
            .horizontally(30)
        
        emailSeparator.pin
            .below(of: emailTextField)
            .height(0.5)
            .horizontally(6)
        
        passwordLabel.pin
            .below(of: emailSeparator)
            .left(25)
            .marginTop(33)
            .sizeToFit()
        
        passwordTextField.pin
            .below(of: passwordLabel)
            .marginTop(10)
            .height(50)
            .horizontally(30)

        passwordSeparator.pin
            .below(of: passwordTextField)
            .height(0.1)
            .horizontally(6)

        logInButton.pin
            .below(of: passwordSeparator)
            .marginTop(66)
            .height(67)
            .horizontally(5)
        
        notRegisteredLabel.pin
            .below(of: logInButton)
            .marginTop(25)
            .hCenter()
            .sizeToFit()
        
        signUpButton.pin
            .below(of: notRegisteredLabel)
            .marginTop(5)
            .hCenter()
            .sizeToFit()
    }
    
    @objc
    func didTaplogInButton() {
        animateButtonOpacity(button: logInButton)
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            print("[DEBUG]: \(FirebaseError.badLoginOrPass)")
            return
        }
        
        authModel.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                let mainTabBarController = MainTabBarController()
                mainTabBarController.modalPresentationStyle = .fullScreen
                self?.present(mainTabBarController, animated: false, completion: nil)
//                UserDefaults.standard.set(email, forKey: "isAuth")
                UserDefaults.standard.setValue(true, forKey: "isAuth")
                
            case .failure(_):
                self?.loginDescription.text = "Bad email or password"
                self?.loginDescription.textColor = .fail
                print("[DEBUG]: \(FirebaseError.badLoginOrPass)")
            }
        }
    }
    
    @objc
    func didTapSignUpButton() {
        let registrationViewController = UINavigationController(rootViewController: RegistrationViewController())
        registrationViewController.modalPresentationStyle = .fullScreen
        self.present(registrationViewController, animated: true, completion: nil)
    }
}
