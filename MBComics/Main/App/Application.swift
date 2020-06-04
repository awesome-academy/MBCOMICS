//
//  Application.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import FirebaseAuth

final class Application {
    static let shared = Application()
    
    fileprivate init() {
        
    }
    
    func initApplication(with window: UIWindow?) {
        guard let window = window else { return }
        window.makeKeyAndVisible()
        if Auth.auth().currentUser == nil {
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        } else {
            window.rootViewController = createTabbar()
        }
    }
    
    func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        
        let createNav = { (vc: UIViewController) in
            return UINavigationController(rootViewController: vc)
        }
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let userVC = UserViewController()
        userVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        tabbar.viewControllers = [createNav(homeVC), createNav(searchVC), createNav(userVC)]
        
        return tabbar
    }
}
