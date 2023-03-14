//
//  SearchController.swift
//  MyPick
//
//  Created by Holly McBride on 14/03/2023.
//

import UIKit

class SearchController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
     
        let labelRect = CGRect(x: 50, y: 100, width: 200, height: 100)
        let label = UILabel(frame: labelRect)
        label.text  = "INSIDE SEARCH CONTROLLER"
        label.numberOfLines = 2
        view.addSubview(label)
        
    }
       
    
}

    

