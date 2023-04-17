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
import FirebaseAuth

class SearchController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    var db2: CollectionReference!
    var currentUser: User?
    let resultsLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DataCell.self, forCellReuseIdentifier: reuseIdentifier)
        searchBar.placeholder = "Search Your Apps"
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
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
                    }
                }
                
            }
        }
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultsLabel)
        resultsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = true
        resultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16).isActive = true
        resultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16).isActive = true
    }
    
    func searchForUserInput(withText searchText: String) {
        var availableServices: [String] = [] // create the array
        let group = DispatchGroup()
        let lowercaseSearchText = searchText.lowercased()
        
        for service in serviceArray {
            group.enter()
            //check if the service has a "movies" subcollection
            let moviesCollection = db2.document(service.name).collection("movies")
            moviesCollection.whereField("MovieTitle", isEqualTo: searchText).getDocuments{ (querySnapshot, error) in
                defer {
                    group.leave()
                }
                
                if let error = error {
                    print("Error gettng documents")
                } else if let doc = querySnapshot?.documents.first {
                    availableServices.append(service.name) // to create a list of the available apps user search is on
                }
            }
        }
        
        group.notify(queue: .main) {
            if availableServices.isEmpty {
                self.resultsLabel.text = "Not available on any of your apps"
            } else {
                let servicesString = availableServices.joined(separator: ", ")
                self.resultsLabel.text = "This is available on: \(servicesString)"
            }
        }
        
    }
    
    //call this function when the user clicks th search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchForUserInput(withText: searchText)
    }
    
    //table view funcs
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
        
        //remove "connect" button - UIBUG
        for subview in cell.contentView.subviews {
            if let button = subview as? UIButton {
                button.removeFromSuperview()
            }
        }
        return cell
    }
}

