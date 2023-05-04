//
//  HomeController.swift
//  MyPick
//
//  Created by Holly McBride on 07/03/2023.
//

import UIKit
import SideMenu
import Lottie

class HomeController: UIViewController {

    // label
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Loading... "
        label.numberOfLines = 2
        return label
    }()
    // button
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("Too Lazy to Search? Its ok..Tap to start", for: .normal)
        button.backgroundColor = UIColor(red: 0.8902, green: 0.9294, blue: 0.9059, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        return button
    } ()
    
    private var tabBarVC: UITabBarController?
    private var menu: SideMenuNavigationController?
    
    
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
                self.label.text = "Welcome Back \(user.username)\n"
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set up side menu
        let menuVC = SideMenuController()
        menu = SideMenuNavigationController(rootViewController: menuVC)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
       // SideMenuManager.default.appPanGestureToPresent(toView: self.view)
        
        //display sideMenu
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(didTapMenuButton))
        menuButton.tintColor = .black
        navigationItem.leftBarButtonItem = menuButton
        
    }
    
    
    //SET UP UI FUNC
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.8902, green: 0.9294, blue: 0.9059, alpha: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogOut))
        self.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        let animationView = LottieAnimationView(name: "65506-tv-robo-walking-animation")
        self.view.addSubview(animationView)
        self.view.addSubview(label)
        self.view.addSubview(button)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: self.view.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -20),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 50)
        ])        
        animationView.loopMode = .loop
        animationView.play()
    }
    
    
    @objc private func didTapMenuButton() {
        present(menu!, animated: true, completion: nil)
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
        
        let vc1 =  FirstViewController()
        let vc2 =  SecondViewController()
        let vc3 =  ThirdViewController()
        let vc4 =  ForthViewController()
        
        vc1.title = "Trending"
        vc2.title = "Search Your Apps"
        vc3.title = "Recent"
        vc4.title = "Account"
        
        tabBarVC.tabBar.backgroundColor = .systemGray2
        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4], animated: false)
        
        guard let items = tabBarVC.tabBar.items else {
            return
        }
        
        //image display
        let images = ["play.circle.fill", "magnifyingglass", "gobackward", "list.dash"]
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true)
        self.tabBarVC = nil
        
    }
    
    //tab 1 - trending
    class FirstViewController: TrendingController {
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Trending"
        }
    }
    //tab 2 - search
    class SecondViewController: SearchController {
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Search Your Apps"
        }
    }
    //tab 3  - account
    class ThirdViewController: RecentlyWatched {
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Recent"
        }
    }
    
    class ForthViewController: TabListController {
        override func viewDidLoad() {
            super.viewDidLoad()
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




