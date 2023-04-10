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

class SearchController: UIViewController, UISearchBarDelegate {
    
    let searchBar = UISearchBar()
    var currentUser: User?
    var db: Firestore!
    var db2: CollectionReference!
    var serviceArray: [Service] = []
    let resultsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search your apps.."
        searchBar.delegate = self
        view.backgroundColor = .lightGray
        //add the search bar to view
        view.addSubview(searchBar)
        
        
        //reference to current user logged in
        AuthService.shared.fetchUser { user, error in
            if let error = error {
                print("Error fetching user: /(error.localizedDescription)")
            } else if let user = user {
                self.currentUser = user
                self.db2 = self.db.collection("users").document(user.userUID ?? "").collection("userServices")
                
            }
        }
        
        db.collection("userServices").getDocuments() { (querySnapshot, error ) in
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
            }
        }
        
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
        var foundSearch: Service?
        for service in serviceArray {
            if service.name.lowercased().contains(searchText.lowercased()) {
                foundSearch = service
                break
            }
        }
        if let service = foundSearch {
            resultsLabel.text = "This is available on \(service.name)"
        } else {
            resultsLabel.text = "Not available on any of your apps"
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let searchText = searchBar.text else { return }
            searchForUserInput(withText: searchText)
        }
    }
    
}

