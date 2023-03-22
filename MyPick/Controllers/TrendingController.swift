//
//  TrendingController.swift
//  MyPick
//
//  Created by Holly McBride on 14/03/2023.
//

import UIKit

class TrendingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        // RAPID/TMBD API FOR CAROSEL VIEW 
        let labelRect = CGRect(x: 50, y: 100, width: 200, height: 100)
        let label = UILabel(frame: labelRect)
        label.text  = "INSIDE TRENDINGCONTROLLER"
        label.numberOfLines = 2
        view.addSubview(label)
        
    }
}
