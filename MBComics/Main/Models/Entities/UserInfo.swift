//
//  UserInfo.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import FirebaseDatabase

struct UserInfo {
    var uid: String
    var displayName: String
    var favoriteComics = [FavoriteComic]()
    
    init(uid: String, displayName: String) {
        self.uid = uid
        self.displayName = displayName
    }
    
    init?(_ snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        
        guard let _displayName = dict["display_name"] as? String else { return nil }
        
        let favComics = snapshot.childSnapshot(forPath: "favorite_comics")
        
        uid = snapshot.key
        displayName = _displayName
        favComics.children.forEach {
            guard let snap = $0 as? DataSnapshot,
                  let comic = FavoriteComic(snap)
            else { return }
            
            favoriteComics.append(comic)
        }
    }
}
