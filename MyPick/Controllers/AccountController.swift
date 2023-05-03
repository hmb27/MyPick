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
    
    // MARK: - UI Components
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo" )
        iv.tintColor = .white
        return iv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogOut))
        
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(logoImageView)
        view.addSubview(tableView)
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at index path: \(indexPath)")
        let backButton = UIBarButtonItem(title: "Return", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        switch indexPath.row {
        case 0:
            let usersDetailsVC = UserDetailsViewController()
            navigationController?.pushViewController(usersDetailsVC, animated: true)
        case 1:
            let userAppsVC = UsersAppsController()
            navigationController?.pushViewController(userAppsVC, animated: true)
        case 2:
            let serviceListVC = ServiceList()
            navigationController?.pushViewController(serviceListVC, animated: true)
        case 3:
            let paymentList =  PaymentList()
            navigationController?.pushViewController(paymentList, animated: true)
        default:
            break
        }
        
    }
    
    //LOG OUT FUNCTION
    /*@objc private func didTapLogOut() {
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
    }*/
}
