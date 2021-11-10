//
//  RegistrationViewController.swift
//  InBrew
//
//  Created by golub_dobra on 28.10.2021.
//

import UIKit
import PinLayout

final class RegistrationViewController: UIViewController {
    private let logoImageView = UIImageView(image: UIImage(named: "logoIcon.png"))
    private let signUpHeader = UILabel()
    private let signUpDescription = UILabel()
    private let usernameLabel = UILabel()
    private let usernameTextField = UITextField()
    private let usernameSeparator = UIView()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailSeparator = UIView()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordSeparator = UIView()
    private let signUpButton = UIButton()
    private let haveAccountLable = UILabel()
    private let loginButton = UIButton()
    private let registrationModel: RegistrationFirebaseModel = RegistrationFirebaseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        signUpHeader.text = "SingUp"
        signUpHeader.font = UIFont(name: "Comfortaa-Bold", size: 26)
        
        signUpDescription.text = "Enter your credentials to continue"
        signUpDescription.font = UIFont(name: "Comfortaa-Bold", size: 16)
        signUpDescription.textColor = .minorText
        
        usernameLabel.text = "Username"
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
        [usernameLabel,
         emailLabel,
         passwordLabel].forEach() {
            ($0).font = UIFont(name: "Comfortaa-Bold", size: 16)
            ($0).textColor = .minorText
         }
        
        usernameTextField.placeholder = "Username"
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        [usernameTextField,
         emailTextField,
         passwordTextField].forEach() {
            ($0).font = UIFont(name: "Comfortaa-Bold", size: 15)
            ($0).borderStyle = .none
            ($0).textColor = .text
         }
        
        passwordTextField.isSecureTextEntry = true
        
        [usernameSeparator,
         emailSeparator,
         passwordSeparator].forEach() {
            ($0).backgroundColor = .separator
         }
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = .primary
        signUpButton.setTitleColor(.lightText, for: .normal)
        signUpButton.layer.cornerRadius = 19
        signUpButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 18)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        [logoImageView,
         signUpHeader,
         signUpDescription,
         usernameLabel,
         usernameTextField,
         usernameSeparator,
         emailLabel,
         emailTextField,
         emailSeparator,
         passwordLabel,
         passwordTextField,
         passwordSeparator,
         signUpButton,
         haveAccountLable,
         loginButton].forEach() {
            view.addSubview($0)
        }
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

    override func viewDidLayoutSubviews() {
        
        logoImageView.pin
            .top(view.pin.safeArea)
            .height(110)
            .width(90)
            .hCenter()
        
        signUpHeader.pin
            .below(of: logoImageView)
            .left(25)
            .marginTop(44)
            .sizeToFit()
        
        signUpDescription.pin
            .below(of: signUpHeader)
            .marginTop(15)
            .left(25)
            .sizeToFit()
        
        usernameLabel.pin
            .below(of: signUpDescription)
            .marginTop(35)
            .left(25)
            .sizeToFit()
        
        usernameTextField.pin
            .below(of: usernameLabel)
            .marginTop(10)
            .height(50)
            .horizontally(30)
        
        usernameSeparator.pin
            .below(of: usernameTextField)
            .height(0.5)
            .horizontally(6)
        
        emailLabel.pin
            .below(of: usernameSeparator)
            .marginTop(21)
            .left(25)
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
            .marginTop(21)
            .left(25)
            .sizeToFit()
        
        passwordTextField.pin
            .below(of: passwordLabel)
            .marginTop(10)
            .height(50)
            .horizontally(30)
        
        passwordSeparator.pin
            .below(of: passwordTextField)
            .height(0.5)
            .horizontally(6)
        
        signUpButton.pin
            .below(of: passwordSeparator)
            .marginTop(41)
            .height(67)
            .horizontally(5)
    }
    
    @objc
    func didTapSignUpButton() {
        animateButtonOpacity(button: signUpButton)
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            self.signUpDescription.text = "Empty user fields!"
            self.signUpDescription.textColor = .fail
            print("[DEBUG]: \(FirebaseError.emptyFields)")
            return
        }
        
        let alertTitle = "18+"
        let alertMessage = "Are you over 18 years old?"
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { [weak self] action in
            guard let self = self else {
                return
            }
            
            self.registrationModel.signUp(username: username,
                                     email: email,
                                     password: password) { newUser in
                switch newUser {
                case .success(_):
                    let authViewController = AuthViewController()
                    authViewController.modalPresentationStyle = .fullScreen
                    self.dismiss(animated: true, completion: nil)
                    
                    UserDefaults.standard.setValue(true, forKey: "isAuth")
                    
                case .failure(_):
                    self.signUpDescription.text = "Bad information about user"
                    self.signUpDescription.textColor = .fail
                    print("[DEBUG]: \(FirebaseError.emptyFields)")
                }
                
            }
        }))

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
            self.signUpDescription.text = "Sorry, but you are too young!"
            self.signUpDescription.textColor = .fail
        }))
        self.present(alert, animated: true, completion: nil)

        
        
    }
    
    @objc
    func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
