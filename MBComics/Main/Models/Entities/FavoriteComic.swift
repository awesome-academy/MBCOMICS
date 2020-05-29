//
//  FavoriteComic.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import FirebaseDatabase

struct FavoriteComic: Comic {
    var id: Int
    var title: String
    var poster: String
    var numberIssues: Int = 0
    
    init(id: Int, title: String, poster: String, numberIssues: Int = 0) {
        self.id = id
        self.title = title
        self.poster = poster
        self.numberIssues = numberIssues
    }
    
    init?(_ snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        
        guard let _comicId = dict["comic_id"] as? Int,
              let _title = dict["title"] as? String,
              let _poster = dict["poster"] as? String,
              let _numberIssues = dict["number_issues"] as? Int
        else { return nil }
        
        id = _comicId
        poster = _poster
        title = _title
        numberIssues = _numberIssues
    }
}

extension FavoriteComic: DatabaseRepresentable {
    var representation: [String : Any] {
        return [ "id": id,
                 "title": title,
                 "poster": poster,
                 "number_issues": numberIssues]
    }
}
