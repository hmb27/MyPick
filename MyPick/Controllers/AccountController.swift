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
            let usersDetailsVC = UserDetailsViewController()
            navigationController?.pushViewController(usersDetailsVC, animated: true)
        case 1:
            cell.textLabel?.text = "Connect Your Apps"
            let serviceList = SearchController()
            navigationController?.pushViewController(serviceList, animated: true)
        case 2:
            cell.textLabel?.text = "Payment List"
            let paymentList =  PaymentList()
            navigationController?.pushViewController(paymentList, animated: true)
        case 3:
            cell.textLabel?.text = "Recently Watched"
            let recentlyWatched = RecentlyWatched()
            navigationController?.pushViewController(recentlyWatched, animated: true)
        case 4:
            cell.textLabel?.text = "Log Out" // add log out code 
        default:
            break
        }
        return cell
    }
    
    func tableView(_tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UserDetailsViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    // LIST VIEW
    
    //USER DETAILS
    //CONNECT YOUR APPS
    //PAYMENT LIST
    //RECENTLY WATCHED
    //LOG OUT
}
