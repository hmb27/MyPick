//
//  AccountController.swift
//  MyPick
//
//  Created by Holly McBride on 14/03/2023.
//

import UIKit

class AccountController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        
        let labelRect = CGRect(x: 50, y: 100, width: 200, height: 100)
        let label = UILabel(frame: labelRect)
        label.text  = "INSIDE ACCOUNTCONTROLLER"
        label.numberOfLines = 2
        view.addSubview(label)
        
    }
}
