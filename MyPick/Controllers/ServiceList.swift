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
import FirebaseAuth


class ServiceList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
            connectButton.setTitle("Connect", for: .normal)
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
            
            guard let db2 = db2 else {
                print("db2 is not yet initialized")
                return
            }
            // retrieving the selected services and adding to "userServices"
            db2.document(currentUser.userUID ?? "").setData([
                selectedService.name: selectedService.url
            ], merge: true) { error in
                if let error = error {
                    print("Error adding service to user: /(error.localizedDescription)")
                } else {
                    print("Service added to user")
                }
            }
        }
        // func to add service to userServices when CONNECT is tapped
    @objc private func didTapConnect(_ sender: UIButton) {
        if let indexPath = tableView.indexPathForSelectedRow {
              let selectedService = serviceArray[indexPath.row]
              let vc = serviceLogIn()
              self.navigationController?.pushViewController(vc, animated: true)
              guard let currentUser = currentUser else {
                  print("No user logged in.")
                  return
              }
                    
            let userServicesDocumentRef = db.collection("users").document(currentUser.userUID ?? "").collection("userServices").document(selectedService.name)
            let batch = db.batch()
                    
            // Add "services" collection and its "movies" and "TVShows" subcollections to "userServices"
              let servicesCollectionRef = db.collection("services")
              let servicesQuery = servicesCollectionRef.whereField("name", isEqualTo: selectedService.name)
              servicesQuery.getDocuments { (snapshot, error) in
                  if let error = error {
                      print("Error getting services collection: \(error.localizedDescription)")
                      return
                  }
                  
                  guard let document = snapshot?.documents.first else {
                      print("No document found for service: \(selectedService.name)")
                      return
                  }
                  
                  
                  let serviceData = document.data()
                  batch.setData(serviceData, forDocument: userServicesDocumentRef) // adds all subocllections to userServices
                  
                  let moviesCollectionRef = servicesCollectionRef.document(document.documentID).collection("movies")
                  let tvShowsCollectionRef = servicesCollectionRef.document(document.documentID).collection("TVShows")
                  
                  let moviesQuery = moviesCollectionRef.order(by: "MovieTitle")
                  let tvShowsQuery = tvShowsCollectionRef.order(by: "showTitle")
                  
                  moviesQuery.getDocuments { (snapshot, error) in
                      if let error = error {
                          print("Error getting movies sub-collection: \(error.localizedDescription)")
                          return
                      }
                      
                      for movieDocument in snapshot!.documents {
                          let movieData = movieDocument.data()
                          let movieRef = userServicesDocumentRef.collection("movies").document(movieDocument.documentID)
                          batch.setData(movieData, forDocument: movieRef)
                      }
                      
                      tvShowsQuery.getDocuments { (snapshot, error ) in
                          if let error = error {
                              print("Error getting TVShows sub-collection: \(error.localizedDescription)")
                              return
                          }
                          for tvShowDocument in snapshot!.documents {
                              let tvShowData = tvShowDocument.data()
                              let tvShowRef = userServicesDocumentRef.collection("TVShows").document(tvShowDocument.documentID)
                              batch.setData(tvShowData, forDocument: tvShowRef)
                          }
                          
                          batch.commit { error in
                              if let error = error {
                                  print("Error adding sub-collections to userServices: \(error.localizedDescription)")
                              } else {
                                  print("Sub-collections added to userServices successfully")
                              }
                          }
                      }
                  }
              }
          }
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
    
    
