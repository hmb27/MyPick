//
//  AccountController.swift
//  MyPick
//
//  Created by Holly McBride on 14/03/2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase

class AccountController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "User Details"
        case 1:
            cell.textLabel?.text = "Connect Your Apps"
        case 2:
            cell.textLabel?.text = "Payment List"
        case 3:
            cell.textLabel?.text = "Recently Watched"
        case 4:
            cell.textLabel?.text = "Log Out" // add log out code
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backButton = UIBarButtonItem(title: "Return", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        switch indexPath.row {
        case 0:
            let usersDetailsVC = UserDetailsViewController()
            navigationController?.pushViewController(usersDetailsVC, animated: true)
        case 1:
            let serviceList = ServiceList()
            navigationController?.pushViewController(serviceList, animated: true)
        case 2:
            let paymentList =  PaymentList()
            navigationController?.pushViewController(paymentList, animated: true)
        case 3:
            let recentlyWatched = RecentlyWatched()
            navigationController?.pushViewController(recentlyWatched, animated: true)
        case 4:
            // add log out code
            break
        default:
            break
        }
        
        
        // LIST VIEW
        
        //USER DETAILS
        //CONNECT YOUR APPS
        //PAYMENT LIST
        //RECENTLY WATCHED
        //LOG OUT
    }
}
