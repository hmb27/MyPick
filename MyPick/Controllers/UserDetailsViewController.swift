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

class UserDetailsViewController: UIViewController {
    
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    var db2: CollectionReference!
    var currentUser: User?
    let headerView = UIView()
    let label = UILabel()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let nameLabel = UILabel()
        let emailLabel = UILabel()
        let stackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        imageView.image = UIImage(named: "ProfilePic")
        db = Firestore.firestore()
        view.addSubview(imageView)
        view.addSubview(stackView)
  
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //DisplayConstraints
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
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
}


