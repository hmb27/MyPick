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

class PaymentList:  UIViewController, UITableViewDataSource, UITableViewDelegate {

        //let headerView = AuthHeaderView(title: "", subTitle: "Sign into your account now")
        let tableView = UITableView()
        let reuseIdentifier = "DataCell"
        var serviceArray: [Service] = []
        var db: Firestore!
        var db2: CollectionReference!
        var currentUser: User?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setupUI()
            db = Firestore.firestore()
            tableView.frame = view.frame
            tableView.dataSource = self
            tableView.allowsSelection = true
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(DataCell.self, forCellReuseIdentifier: reuseIdentifier)
            view.addSubview(tableView)
            self.setUpNavigationBar()
            
            //fetching & checking current user logged in to add services to their fb
            AuthService.shared.fetchUser { user, error in
                if let error = error {
                    print("Error fetching user: /(error.localizedDescription)")
                } else if let user = user {
                    self.currentUser = user
                    self.db2 = self.db.collection("users").document(user.userUID ?? "").collection("userServices")
                }
            }
            
            //retrieve the data from firebase
            db.collection("services").getDocuments() { (querySnapshot, error ) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let name = data["name"] as? String,
                           let url = data["url"] as? String {
                            var service = Service(name: name, url: url)
                            self.serviceArray.append(service)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
            
            
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                self.navigationController?.navigationBar.isHidden = true
            }
            
            //UI SET UP
            private func setupUI() {
                self.view.addSubview(tableView)
                tableView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                    tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ])
                
            }
            
            private func setUpNavigationBar() {
                let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
                navBar.barTintColor = .white
                navBar.tintColor = .black
                let returnButton = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(didTapReturn))
                let navItem = UINavigationItem(title: "")
                navItem.leftBarButtonItem = returnButton
                navBar.setItems([navItem], animated: false)
                view.addSubview(navBar)
            }
            
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
                
                //adding the connect button to each cell
                let connectButton = UIButton(type: .system)
                connectButton.setTitle("Add Renewal Date", for: .normal)
                connectButton.addTarget(self, action: #selector(didTapConnect), for: .touchUpInside)
                connectButton.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(connectButton)
                NSLayoutConstraint.activate([
                    connectButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    connectButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20)
                ])
                
                return cell
            }
            
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedService = serviceArray[indexPath.row]
            guard let currentUser = currentUser else {
                print("No user logged in.")
                return
            }
        }
    
        
    @objc private func didTapConnect(_ sender: UIButton) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedService = serviceArray[indexPath.row]
            let vc = DateClickerController()
            self.navigationController?.pushViewController(vc, animated: true)
            // FIX THIS FUNC TO ADD PAYMENT LIST TO USER
        }
    }
           
            @objc private func didTapReturn(){
                navigationController?.popViewController(animated: true)
            }
            
        }
        
    

