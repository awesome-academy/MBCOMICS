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
        
        guard let comicId = Int(snapshot.key),
              let title = dict["title"] as? String,
              let poster = dict["poster"] as? String,
              let numberIssues = dict["number_issues"] as? Int
        else { return nil }
        
        id = comicId
        self.poster = poster
        self.title = title
        self.numberIssues = numberIssues
    }
}

extension FavoriteComic: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case numberIssues = "number_issues"
        case poster = "poster"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        numberIssues = try values.decode(Int.self, forKey: .numberIssues)
        poster = try values.decode(String.self, forKey: .poster)
        title = try values.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(numberIssues, forKey: .numberIssues)
        try container.encode(poster, forKey: .poster)
        try container.encode(title, forKey: .title)
    }
}

extension FavoriteComic: DatabaseRepresentable {
    var representation: [String: Any] {
        return [ "title": title,
                 "poster": poster,
                 "number_issues": numberIssues]
    }
}
