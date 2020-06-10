//
//  AppInfo.swift
//  MBComics
//
//  Created by HoaPQ on 6/8/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import FirebaseAuth

class AppInfo {
    static var isLogin: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static var currentUser: UserInfo? {
        get {
            guard let data = UserDefaults.standard.data(forKey: kUserInfo) else {
                return nil
            }
            guard let user = try? PropertyListDecoder().decode(UserInfo.self, from: data) else {
                return nil
            }
            return user
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: kUserInfo)
            }
        }
    }
}
