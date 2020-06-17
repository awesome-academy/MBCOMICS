//
//  AppDelegate.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        window = UIWindow()
        Application.shared.initApplication(with: window)
        Application.shared.changeRootViewController = changeRootViewController
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app,
                                                             open: url,
                                                             sourceApplication: options[.sourceApplication] as? String,
                                                             annotation: options[.annotation])
        return handled || GIDSignIn.sharedInstance().handle(url)
    }
    
    private func changeRootViewController() {
        Application.shared.initApplication(with: window)
    }
}
