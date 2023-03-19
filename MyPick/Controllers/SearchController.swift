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


class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let tableView = UITableView()
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    
    //Database location: Belgium (europe-west1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.register(DataCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        
        
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
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }

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
    



