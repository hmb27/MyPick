//
//  ListModel.swift
//  MyPick
//
//  Created by Holly McBride on 14/03/2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class ListModel: ObservableObject{
    
    @Published var services = [Service]()

    private var db = Firestore.firestore()
    
    func fetchData() {
    db.collection("services").addSnapshotListener {( querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
            print("No Documents")
            return
                //handle error
            }
        
        self.services = documents.map { (queryDocumentSnapshot) -> Service in
            let data = queryDocumentSnapshot.data()
            
            let name = data["name"] as? String ?? ""
            let url = data["url"] as? String ?? ""
            
            return Service(name: name, url: url)
        }
        
        
        }
        }
        
    }
