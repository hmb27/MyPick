//
//  ListModel.swift
//  MyPick
//
//  Created by Holly McBride on 14/03/2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class ViewModel: UIViewController {
    
    @Published var Services = [services]()
    

    private var db = Firestore.firestore()
    
    func fetchData() {
    db.collection("services").addSnapshotListener {( querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
            print("No Documents")
            return
                //handle error
            }
        
        self.Services = documents.map { (queryDocumentSnapshot) -> services in
            let data = queryDocumentSnapshot.data()
            let id = data["id"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let url = data["url"] as? String ?? ""
            return services(id: id, name: name, url: url)
        }
        }
        
    }
    
}
