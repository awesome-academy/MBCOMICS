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
    var avatarColor: UIColor
    var favoriteComics = [FavoriteComic]()
    
    init(uid: String, displayName: String) {
        self.uid = uid
        self.displayName = displayName
        avatarColor = UIColor.random
    }
    
    init?(_ snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        
        guard let displayName = dict["display_name"] as? String,
              let color = dict["avatar_color"] as? String
              else { return nil }
        
        let favComics = snapshot.childSnapshot(forPath: "favorite_comics")
        
        uid = snapshot.key
        avatarColor = UIColor(hexString: color)
        self.displayName = displayName
        favComics.children.forEach {
            guard let snap = $0 as? DataSnapshot,
                  let comic = FavoriteComic(snap)
            else { return }
            
            favoriteComics.append(comic)
        }
    }
}

extension UserInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case favoriteComics = "favorite_comics"
        case uid = "uid"
        case avatarColor = "avatar_color"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try values.decode(String.self, forKey: .displayName)
        favoriteComics = try values.decode([FavoriteComic].self, forKey: .favoriteComics)
        uid = try values.decode(String.self, forKey: .uid)
        let color = try values.decode(String.self, forKey: .avatarColor)
        avatarColor = UIColor(hexString: color)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(favoriteComics, forKey: .favoriteComics)
        try container.encode(avatarColor.hexString, forKey: .avatarColor)
    }
}

extension UserInfo: DatabaseRepresentable {
    var representation: [String: Any] {
        var comics = [String: Any]()
        favoriteComics.forEach { comics["\($0.id)"] = $0.representation }
        
        return ["display_name": displayName,
                "favorite_comics": comics,
                "avatar_color": avatarColor.hexString]
    }
}
