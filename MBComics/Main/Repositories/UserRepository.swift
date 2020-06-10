//
//  UserRepository.swift
//  MBComics
//
//  Created by HoaPQ on 6/8/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase

protocol UserRepositoryType {
    func login(with credential: AuthCredential,
               completion: @escaping (Error?) -> Void)
    
    func setUpCurrentUser()
    
    func addFavoriteComic(comic: FavoriteComic)
    
    func removeFavoriteComic(comic: FavoriteComic)
}

struct UserRepository: UserRepositoryType {
    let api: APIService
    
    func login(with credential: AuthCredential, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(with: credential) { (_, error) in
            completion(error)
        }
    }
    
    func setUpCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }
        let userInfo = AppInfo.currentUser ?? UserInfo(uid: user.uid,
                                                       displayName: user.displayName ?? user.providerID)
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(user.uid)
        userRef.updateChildValues(userInfo.representation)
        userRef.observe(.value) { snapshot in
            if let info = UserInfo(snapshot) {
                AppInfo.currentUser = info
            }
        }
    }
    
    func addFavoriteComic(comic: FavoriteComic) {
        guard let user = Auth.auth().currentUser else { return }
        
        let ref = Database.database().reference().child("users/\(user.uid)/favorite_comics/\(comic.id)")
        ref.updateChildValues(comic.representation)
    }
    
    func removeFavoriteComic(comic: FavoriteComic) {
        guard let user = Auth.auth().currentUser else { return }
        
        let ref = Database.database().reference().child("users/\(user.uid)/favorite_comics/\(comic.id)")
        ref.removeValue()
    }
}
