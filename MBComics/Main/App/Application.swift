//
//  Application.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

final class Application {
    static let shared = Application()
    
    fileprivate init() {
        
    }
    
    func initApplication(with window: UIWindow?) {
        guard let window = window else { return }
        window.makeKeyAndVisible()
        window.rootViewController = UINavigationController(rootViewController: ViewController())
    }
}
