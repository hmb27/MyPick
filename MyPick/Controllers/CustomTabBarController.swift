//
//  CustomTabBarController.swift
//  MyPick
//
//  Created by Holly McBride on 14/03/2023.
//

import UIKit

class customTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchNavController = UINavigationController(rootViewController: SearchController())
        searchNavController.tabBarItem.title = "Search"
        
            }
}
