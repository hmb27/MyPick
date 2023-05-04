//
//  UserDetailsViewController.swift
//  MyPick
//
//  Created by Holly McBride on 24/03/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import Lottie

class UserDetailsViewController: UIViewController {
    
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    var db2: CollectionReference!
    var currentUser: User?
    let headerView = UIView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.8627, green: 0.7686, blue: 0.9294, alpha: 1.0)
        let nameLabel = UILabel()
        let emailLabel = UILabel()
        let stackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        let animationView = LottieAnimationView(name: "96249-user")
        self.view.addSubview(animationView)
        db = Firestore.firestore()
        view.addSubview(stackView)
  
        animationView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //DisplayConstraints
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            stackView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 32),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        animationView.loopMode = .loop
        animationView.play()
        
        //log out button to navigation bar
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogOut))
        navigationItem.rightBarButtonItem = logoutButton
        
        //reference to current user logged in
        AuthService.shared.fetchUser { user, error in
            if let error = error {
                print("Error fetching user: /(error.localizedDescription)")
            } else if let user = user {
                self.currentUser = user
                self.db2 = self.db.collection("users").document(user.userUID ?? "").collection("userServices")
                self.db2.getDocuments() { (QuerySnapshot, error ) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in QuerySnapshot!.documents {
                            let data = document.data()
                            if let name = data["name"] as? String,
                               let url = data["url"] as? String {
                                let service = Service(name: name, url: url)
                                self.serviceArray.append(service)
                            }
                        }
                        
                        nameLabel.text = "Username: \(user.username ?? "N/A")"
                        emailLabel.text = "Email: \(user.email ?? "N/A")"
                    }
                }
                
            }
        }
    }
    
    @objc private func didTapLogOut() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as?
                SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}


