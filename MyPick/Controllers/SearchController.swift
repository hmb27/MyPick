//
//  SearchController.swift
//  MyPick
//
//  Created by Holly McBride on 22/03/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class SearchController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    let connectButton = TableButton(title: "Connect", fontSize: .med)
    
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
        view.addSubview(connectButton)
        //self.connectButton.addTarget(self, action: #selector(didTapConnect), for: .touchUpInside)
        
        
        db.collection("services").getDocuments() { (querySnapshot, error ) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let name = data["name"] as? String,
                       let url = data["url"] as? String {
                        let service = Service(name: name, url: url)
                        self.serviceArray.append(service)
                        //let Connect = CustomButton(title: "Connect.", fontSize: .med)
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
        //self.view.addSubview(headerView)
        self.view.addSubview(tableView)
        self.view.addSubview(connectButton)
        
        //headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            //self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            //self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            //self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            // self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            connectButton.topAnchor.constraint(equalTo: self.view.topAnchor),
            connectButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            connectButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            connectButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
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
        return cell
    }
    
}

