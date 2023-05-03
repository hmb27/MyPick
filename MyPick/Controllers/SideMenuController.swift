//
//  SideMenuController.swift
//  MyPick
//
//  Created by Holly McBride on 01/05/2023.
//

import Foundation
import UIKit
import SideMenu
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

class SideMenuController: UITableViewController {
    
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    var db2: CollectionReference!
    var currentUser: User?
    let resultsLabel = UILabel()
    let headerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
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
                    }
                }
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Account Details"
        case 1:
            cell.textLabel?.text = "Your Apps"
        case 2:
            cell.textLabel?.text = "Connect"
        case 3:
            cell.textLabel?.text = "Subscription Renewal Dates"
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var rootViewController: UIViewController?
        switch indexPath.row {
        case 0:
            rootViewController = UserDetailsViewController()
        case 1:
            rootViewController = UsersAppsController()
        case 2:
            rootViewController = ServiceList()
        case 3:
            rootViewController = PaymentList()
        default:
            break
        }
        
        if let viewController = rootViewController {
            viewController.view.backgroundColor = .white
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true, completion: nil)
    
            }
        }
    }

