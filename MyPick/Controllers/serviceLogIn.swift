//
//  serviceLogIn.swift
//  MyPick
//
//  Created by Holly McBride on 22/03/2023.
//

import UIKit

class serviceLogIn:  UIViewController {
  
    /*override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black*/
        
        
        /*let labelRect = CGRect(x: 50, y: 100, width: 200, height: 100)
        let label = UILabel(frame: labelRect)
        label.textColor = .white
        label.text  = "INSIDE SERVICE LOGIN"
        label.numberOfLines = 2
        view.addSubview(label)*/
        
        //MARK: - UI Components
        private let headerView = serviceHeaderView(title: "Sign In", subTitle: "Sign into your account now")
        
        private let emailField = CustomTextField(fieldType: .email)
        private let passwordField = CustomTextField(fieldType: .password)
        
        private let signInButton = ServiceButton(title: "Sign In", hasBackground: true, fontSize: .big)
        
        
        //MARK: Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setupUI()
            
            self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
            
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isHidden = true
            
            AlertManager.showInvalidEmailAlert(on: self)
            
        }

        
        //MARK: -UI Setup
        private func setupUI() {
            self.view.backgroundColor = .black
            
            self.view.addSubview(headerView)
            self.view.addSubview(emailField)
            self.view.addSubview(passwordField)
            self.view.addSubview(signInButton)
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            emailField.translatesAutoresizingMaskIntoConstraints = false
            passwordField.translatesAutoresizingMaskIntoConstraints = false
            signInButton.translatesAutoresizingMaskIntoConstraints = false
 
            NSLayoutConstraint.activate([
                self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.headerView.heightAnchor.constraint(equalToConstant: 222),
                
                self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
                self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.emailField.heightAnchor.constraint(equalToConstant: 55),
                self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
                self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.passwordField.heightAnchor.constraint(equalToConstant: 55),
                self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
                self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.signInButton.heightAnchor.constraint(equalToConstant: 55),
                self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            ])
            
        }
        
        //MARK: Selectors
        @objc private func didTapSignIn() {
            let loginRequest = LoginUserRequest(
                email: self.emailField.text ?? "",
                password: self.passwordField.text ?? ""
            )
            
            //email check
            if !Validator.isValidEmail(for: loginRequest.email) {
                AlertManager.showInvalidEmailAlert(on: self)
                return
            }
            
            //password check
            if !Validator.isPasswordValid(for: loginRequest.password) {
                AlertManager.showInvalidPasswordAlert(on: self)
                return
            }
        
            AuthService.shared.signIn(with: loginRequest) { error in
                if let error = error {
                    AlertManager.showSignInErrorAlert(on: self, with: error)
                    return
                }
                
                if let sceneDelegate = self.view.window?.windowScene?.delegate as?
                    SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
            //let vc = HomeController()
            //let nav = UINavigationController(rootViewController: vc)
            //nav.modalPresentationStyle = .fullScreen
            //self.present(nav, animated: false, completion: nil)
        }
    
}

