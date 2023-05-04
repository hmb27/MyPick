//
//  PaymentList.swift
//  MyPick
//
//  Created by Holly McBride on 24/03/2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

class UsersAppsController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let headerView = UIView()
    let tableView = UITableView()
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    var db2: CollectionReference!
    var currentUser: User?
    var selectedService: Service?
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        view.backgroundColor = UIColor(red: 0.8902, green: 0.9294, blue: 0.9059, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(DataCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        //header view
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        
        //UILabel
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
        
        //set background color to white
        view.backgroundColor = .white
        headerView.backgroundColor = .white
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
                        self.tableView.reloadData()
                    }}}}
        
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true }
    
    // TABLE VIEW FUNCS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DataCell else {
            return UITableViewCell()
        }
        let service = serviceArray[indexPath.row]
        cell.dataTitleText.text = service.name
        let storageRef = Storage.storage().reference(forURL: service.url)
        storageRef.getData(maxSize: 28060876) { (data, error) in
            if let err = error {
                print(err)
            } else {
                if let image = data {
                    let myImage = UIImage(data: image)
                    cell.dataImageView.image = myImage
                }
            }
        }
        //removing current incorrect connect button - UIBUG
        for subview in cell.contentView.subviews {
            if let button = subview as? UIButton {
                button.removeFromSuperview()
            }
        }
        
        //adding the remove button to each cell
        let removeButton = UIButton(type: .system)
        removeButton.setTitle("Remove", for: .normal)
        removeButton.addTarget(self, action: #selector(removeButtonTapped(_ :)), for: .touchUpInside)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(removeButton)
        NSLayoutConstraint.activate([
            removeButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20)
        ])
        
        return cell
    }
    
    
    //remove service from list view & Firebase databse
    @objc func removeButtonTapped(_ sender: UIButton) {
        let serviceToRemove = serviceArray[sender.tag]
        db2.document(serviceToRemove.name).delete() { error in
            if let error = error {
                print("Error removing service: \(error)")
            } else {
                self.serviceArray.remove(at: sender.tag)
                self.tableView.reloadData() // update table view
            }
        }
    }
    
    //LOG OUT FUNCTION
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

