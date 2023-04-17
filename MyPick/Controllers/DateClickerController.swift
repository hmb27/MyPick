//
//  DateClickerController.swift
//  MyPick
//
//  Created by Holly McBride on 17/04/2023.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

class DateClickerController:  UIViewController {
    
    var db: Firestore!
    var db2: CollectionReference!
    var currentUser: User?
    var serviceArray: [Service] = []
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .purple
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        view.addSubview(datePicker)
        datePicker.center = view.center

    }
}
