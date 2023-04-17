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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        let labelRect = CGRect(x: 50, y: 100, width: 200, height: 100)
        let label = UILabel(frame: labelRect)
        label.text  = "INSIDE USERDETAILS"
        label.numberOfLines = 2
        view.addSubview(label)
    }
}
       
        
        
        
        
        
        
        
        
        
        
        
        /*super.viewDidLoad()
        AuthService.shared.fetchUser { [weak self]user, error in
                guard let self = self else { return }
                if let error = error {
                    AlertManager.showFetchingUserError(on: self, with: error)
                    return
                }
                if let user = user {
                    let labelRect = CGRect(x: 50, y: 100, width: 200, height: 100)
                    let label = UILabel(frame: labelRect)
                    self.label.text = "Username: \(user.username)"
                }
            }
            
        }
    
    
    private func setupUI() {
        self.view.backgroundColor = .systemPurple
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }

    }

*/

