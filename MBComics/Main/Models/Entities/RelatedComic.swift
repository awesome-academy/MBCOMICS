//
//  RelatedComic.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

struct RelatedComic: Comic {
    var id: Int
    var title: String
    var poster: String
    var numberIssues: Int
    
    init(_ json: JSON) {
        id = json["_id"].intValue
        title = json["title"].stringValue
        poster = json["cover"].stringValue
        numberIssues = 0
    }
}
