//
//  SearchController.swift
//  MyPick
//
//  Created by Holly McBride on 14/03/2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase


class ServiceList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let headerView = AuthHeaderView(title: "", subTitle: "Sign into your account now")
    
    
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
        self.connectButton.addTarget(self, action: #selector(didTapConnect), for: .touchUpInside)
        
        
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
        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
        self.view.addSubview(connectButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
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
    
    /*func tableView(_tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = serviceArray[indexPath.row]
        let alertController = UIAlertController(title: "Connect",message:nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Connect", style: .default, handler: { _ in
        }))
        present(alertController, animated: true, completion: nil)
    }*/
    
    @objc private func didTapConnect() {
    //print("connect button tapped")
    let vc = serviceLogIn()
    self.navigationController?.pushViewController(vc, animated: true)
    }
    
}













/*@IBOutlet weak var tableView : UITableView!
 var serviceArray : [Service] = []
 let reuseIdentifier: String! = "DataCell"
 
 var ref : DatabaseReference!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 ref = Database.database().reference()
 if let tableView = tableView {
 tableView.delegate = self
 tableView.dataSource = self
 tableView.register(DataCell.self, forCellReuseIdentifier: reuseIdentifier)
 }
 fetchFirebaseData()
 }
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 //tableView.register(DataCell.self, forCellReuseIdentifier: reuseIdentifier)
 }
 
 
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return serviceArray.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DataCell else {
 
 return UITableViewCell()
 }
 
 cell.setValues(data: serviceArray[indexPath.row])
 
 return cell
 }
 func fetchFirebaseData() {
 ref.child("services").observeSingleEvent(of: .value, with: {snapshot in
 let enumerator = snapshot.children
 while let rest = enumerator.nextObject() as? FirebaseDatabase.DataSnapshot {
 let value = rest.value as? NSDictionary
 var data = Service.init()
 let url = value?["url"] as? String ?? ""
 let title = value?["name"] as? String ?? ""
 data.setData(url: url, name: title)
 self.serviceArray.append(data)
 }
 
 self.tableView.reloadData()
 
 }) {error in
 print (error.localizedDescription)
 }
 }
 } */



/*// READ THE FIREBASE DATA
 func getDatabaseServices() {
 //path
 let collection = db.collection("services")
 //get docs
 collection.getDocuments { snapshot, error in
 if error == nil && snapshot != nil { // no erros and data
 //array of services
 var services = [Service]() // array passed into table
 //loop through docs returned
 for doc in snapshot!.documents{
 //create a new service instance
 var s = Service(name: "name", url: "url")
 // s.id = doc["id"] as? String ?? ""
 s.name = doc["name"] as? String ?? ""
 s.url = doc["url"] as? String ?? ""
 services.append(s)
 }
 
 DispatchQueue.main.async{
 self.services = services
 }
 }
 }
 }*/



//data from firebase
/*ref.child("services").observeSingleEvent(of: .value, with: { snapshot in
 if let servicesDict = snapshot.value as? [String: Any] {
 for serviceID in servicesDict.keys {
 if let serviceData = servicesDict[serviceID] as? [String: Any],
 let name = serviceData["name"] as? String,
 let url = serviceData["url"] as? String {
 let service = Service(name: name, url: url)
 self.serviceArray.append(service)
 }
 }
 self.tableView.reloadData()
 }
 
 })*/


