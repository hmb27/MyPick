//
//  HomeController.swift
//  MyPick
//
//  Created by Holly McBride on 07/03/2023.
//

import UIKit
import SideMenu

class HomeController: UIViewController {
    
    //var menu: SideMenuNavigationController?
    //MARK: - UI Components
    // label
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Loading... "
        label.numberOfLines = 2
        return label
    }()
    // button
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("lets go", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        return button
    } ()
    
    private var tabBarVC: UITabBarController?
    
    //USER LOG IN - HOME DISPLAY PAGE - Fetching user - displaying user name
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        AuthService.shared.fetchUser { [weak self]user, error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            if let user = user {
                self.label.text = "Welcome \(user.username)\n lets get started"
            }
        }
        
    }
    
    
    //SET UP UI FUNC
    private func setupUI() {
        self.view.backgroundColor = .systemPurple
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogOut))
        self.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        //self.button.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
        self.view.addSubview(label)
        self.view.addSubview(button)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    //
    @objc func didTapButton() {
        
        if let tabBarVC = self.tabBarVC {
            self.present(tabBarVC, animated: true)
            return
        }
        
        //create another version of tabbar
        let tabBarVC  = UITabBarController()
        self.tabBarVC = tabBarVC
        
        let vc1 = UINavigationController(rootViewController: FirstViewController())
        let vc2 = UINavigationController(rootViewController: SecondViewController())
        let vc3 = UINavigationController(rootViewController: ThirdViewController())
        
        vc1.title = "Trending"
        vc2.title = "Search"
        vc3.title = "Account"
        
        tabBarVC.tabBar.backgroundColor = .systemGray2
        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        
        guard let items = tabBarVC.tabBar.items else {
            return
        }
        
        //image display
        let images = ["play.circle.fill", "magnifyingglass", "gear"]
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true)
        self.tabBarVC = nil
        
    }
    
    //tab 1 - trending
    class FirstViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            let vc = TrendingController()
            self.navigationController?.pushViewController(vc, animated: true)
            title = "Trending"
        }
    }
    //tab 2 - search
    class SecondViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            let vc = SearchController()
            self.navigationController?.pushViewController(vc, animated: false)
            title = "Search"
        }
    }
    //tab 3  - account
    class ThirdViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            let vc = AccountController()
            self.navigationController?.pushViewController(vc, animated: false)
            title = "Account"
        }
    }
    //}
    //LOG OUT FUNCTION
    @objc private func didTapLogOut() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as?
                SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}



