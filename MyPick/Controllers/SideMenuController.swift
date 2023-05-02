//
//  SideMenuController.swift
//  MyPick
//
//  Created by Holly McBride on 01/05/2023.
//

import Foundation
import UIKit
import SideMenu

class SideMenuController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Account Details"
        case 1:
            cell.textLabel?.text = "Connect Your Apps"
        case 2:
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
            rootViewController = ServiceList()
        case 2:
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

