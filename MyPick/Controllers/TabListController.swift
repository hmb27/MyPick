//
//  TabListController.swift
//  MyPick
//
//  Created by Holly McBride on 03/05/2023.
//

import Foundation
import UIKit
import SideMenu
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

class TabListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
        // Create table view
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Datacell")
        
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Datacell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Your Apps"
            case 1:
                cell.textLabel?.text = "Connect"
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Account"
            case 1:
                cell.textLabel?.text = "Manage Subscriptions"
            case 2:
                cell.textLabel?.text = "Log Out "
            default:
                break
            }
        default:
            break
        }
        
        cell.selectionStyle = .default
        
        cell.accessoryType = .disclosureIndicator // arrow
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var rootViewController: UIViewController?
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                rootViewController = UsersAppsController()
            case 1:
                rootViewController = ServiceList()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                rootViewController = UserDetailsViewController()
            case 1:
                rootViewController = PaymentList()
                //case 2:
                //   let logoutVC = HelpFeedbackViewController()
                //  navigationController?.pushViewController(helpFeedbackVC, animated: true)
            default:
                break
            }
        default:
            break
        }
        
        if let viewController = rootViewController {
            viewController.view.backgroundColor = .white
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController,animated: true,completion: nil)
        }
    }
}

