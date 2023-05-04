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
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    var db2: CollectionReference!
    var currentUser: User?
    let headerView = UIView()
    var selectedService: Service?
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        searchBar.placeholder = "Search Your Apps"
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DataCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        self.view.backgroundColor = .white
        
        //header view - color change
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        
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
                            }}}}}}
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    func searchForUserInput(withText searchText: String) {
        var movieAvailable = false
        var availableServices: [Service] = []
        let group = DispatchGroup()
        let lowercaseSearchText = searchText.lowercased()
        
        for service in serviceArray {
            group.enter()
            let moviesCollection = db2.document(service.name).collection("movies")
            moviesCollection.whereField("MovieTitle", isEqualTo: searchText).getDocuments{ (querySnapshot, error) in
                defer {
                    group.leave()
                }
                
                if let error = error {
                    print("Error getting documents")
                } else if let doc = querySnapshot?.documents.first {
                    availableServices.append(service)
                    movieAvailable = true
                }
            }
        }
        
        group.notify(queue: .main) {
            if !movieAvailable {
                self.selectedService = nil
                //log message
                print("not available on any of users services")
                //alert action
                let alertController = UIAlertController(title: "Movie Not Available", message: "Sorry, the movie you searched for is not available on any of your services.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.serviceArray = availableServices
                self.selectedService = availableServices.first
                self.tableView.reloadData()
            }
            print("availableServices: \(availableServices)") //log message -  print line to check the correct services are being called with the available movie
            //self.tableView.reloadData() - removes UI BUG, displaying all userServices
        }
    }
    
    //call this function when the user clicks th search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchForUserInput(withText: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty {
            //clear the search results
            self.serviceArray.removeAll()
            //add the user details again to get reference to userServices
            AuthService.shared.fetchUser { user, error in
                if let error = error {
                    print("Error fetching user: \(error.localizedDescription)")
                } else if let user = user {
                    self.currentUser = user
                    self.db2 = self.db.collection("users").document(user.userUID ?? "").collection("userServices")
                    self.db2.getDocuments() { (querySnapshot, error ) in
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
                            // self.tableView.reloadData() // remove duplication of userServices table display
                        }
                    }
                }
            }
        }
    }
    
    //table view funcs
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceArray.count
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DataCell else {
            return UITableViewCell()
        }
        let service = serviceArray[indexPath.row]
        //cell.textLabel?.text = service.name
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
        
        //adding the Watch button to each cell
        let watchButton = UIButton(type: .system)
        watchButton.setTitle("Watch Now", for: .normal)
        watchButton.addTarget(self, action: #selector(watchNow(_ :)), for: .touchUpInside)
        cell.contentView.addSubview(watchButton)
        let imageView = UIImageView(image: UIImage(named: "play.cirlce"))
        cell.contentView.addSubview(imageView)
        
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            watchButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            watchButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20),
            imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
            ])
        return cell
    }
    
    
    @objc func watchNow(_ sender: UIButton) {
        }
        
    }



