//
//  DetailComic.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

struct DetailComic: Comic {
    var authors: [String]
    var genres: [String]
    var id: Int
    var title: String
    var publisher: String
    var year: String
    var status: String
    var summary: String
    var poster: String
    var numberIssues: Int
    var issues = [Issue]()
    var relatedComics = [Comic]()
    
    init(_ json: JSON) {
        authors = json["author"].arrayObject as? [String] ?? []
        genres = json["genre"].arrayObject as? [String] ?? []
        id = json["_id"].intValue
        poster = json["cover"].stringValue
        numberIssues = json["number_issues"].intValue
        publisher = json["publisher"].stringValue
        title = json["title"].stringValue
        status = json["status"].stringValue
        year = json["year"].stringValue
        summary = json["summary"].stringValue
        issues = json["issues"].arrayValue.map { Issue($0) }
        relatedComics = json["similar"].arrayValue.map { RelatedComic($0) }
    }
}
