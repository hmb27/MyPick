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
    
    let headerView = UIView()
    let tableView = UITableView()
    let reuseIdentifier = "DataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    var db2: CollectionReference!
    var currentUser: User?
    let datePicker = UIDatePicker()
    var selectedService: Service?
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
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
        titleLabel.text = "Add your next subscription renewal date for your selected apps"
        titleLabel.font = UIFont(name: "Helvetica", size: 30) // FIX TITLE TO LOOK NICER
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        headerView.addSubview(titleLabel)
        
        //set up date picker
        datePicker.datePickerMode = .date
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            
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
        
        //set only image - no name
        let storageRef = Storage.storage().reference(forURL: service.url)
        storageRef.getData(maxSize: 28060876) { (data, error) in
            if let err = error {
                print(err)
            } else {
                if let image = data {
                    let myImage = UIImage(data: image)
                    cell.dataImageView.image = myImage }}}
        
        
        
        //add date clicker to cell
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        //datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        cell.accessoryView = datePicker
        
        
        //remove "connect" button - UIBUG
        for subview in cell.contentView.subviews {
            if let button = subview as? UIButton {
                button.removeFromSuperview() }}
        return cell
        
    }
    
    
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            print("Error: selectedIndexPath is nil")
            return
        }
        
        let selectedService = serviceArray[selectedIndexPath.row]
        let userServicesDocRef = db.collection("users").document(currentUser?.userUID ?? "").collection("userServices").document(selectedService.name)
        let subscriptionRenewalDateCollectionRef = userServicesDocRef.collection("Subscription Renewal Date")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: sender.date)
        
        // Check if the selected date already exists in the subcollection
        subscriptionRenewalDateCollectionRef.whereField("renewalDate", isEqualTo: dateString).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else if let snapshot = snapshot, !snapshot.isEmpty {
                print("Selected date already exists in the subcollection")
            } else {
                // Create the subcollection if it doesn't exist
                userServicesDocRef.setData(["Subscription Renewal Date": [:]], merge: true) { error in
                    if let error = error {
                        print("Error creating subcollection: \(error)")
                    } else {
                        // Add the selected date to the subcollection
                        subscriptionRenewalDateCollectionRef.addDocument(data: ["renewalDate": dateString]) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                            } else {
                                print("Selected date added to the subcollection")
                            }
                        }
                    }
                }
            }
        }
    }
    /*@objc private func datePickerValueChanged(_ sender: UIDatePicker) {
     guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
     print("Error: selectedIndexPath is nil")
     return
     }
     
     let selectedService = serviceArray[selectedIndexPath.row]
     let userServicesDocRef = db.collection("users").document(currentUser.userUID ?? "").collection("userServices").document(selectedService.name)
     let subscriptionRenewalDateCollectionRef = userServicesDocRef.collection("subscriptionRenewalDate")
     subscriptionRenewalDateCollectionRef.addDocument(data: ["renewalDate": selectedDate])
     
     
     // Check if the subscriptionRenewalDate subcollection already exists
     userServicesDocRef.collection("subscriptionRenewalDate").getDocuments { (querySnapshot, error) in
     if let error = error {
     print("Error getting documents: \(error)")
     } else {
     if querySnapshot?.isEmpty ?? true {
     // subscriptionRenewalDate subcollection does not exist, create it
     userServicesDocRef.setData(["subscriptionRenewalDate": true], merge: true) { error in
     if let error = error {
     print("Error adding document: \(error)")
     } else {
     // Add selected date as a new document in the subscriptionRenewalDate subcollection
     subscriptionRenewalDateCollectionRef.setData(["date": selectedDate]) { error in
     if let error = error {
     print("Error adding document: \(error)")
     } else {
     print("Document added with ID: \(subscriptionRenewalDateCollectionRef.documentID)")
     }
     }
     }
     }
     } else {
     // subscriptionRenewalDate subcollection already exists, add selected date as a new document
     subscriptionRenewalDateCollectionRef.setData(["date": selectedDate]) { error in
     if let error = error {
     print("Error adding document: \(error)")
     } else {
     print("Document added with ID: \(subscriptionRenewalDateCollectionRef.documentID)")
     }
     }
     }
     }
     }
     
     }
     }*/
}
