//
//  RecentlyWatched.swift
//  MyPick
//
//  Created by Holly McBride on 24/03/2023.
//

import UIKit
import SideMenu

class RecentlyWatched:  UIViewController {
    
    private var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Recently Watched"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Display sideMenu
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(didTapMenuButton))
        navigationItem.leftBarButtonItem = menuButton
        
        //set up sideMenu
        let menuVC = SideMenuController()
        menu = SideMenuNavigationController(rootViewController: menuVC)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        
    }
    
    
    @objc private func didTapMenuButton() {
        present(menu!, animated: true, completion: nil)
    }
}





