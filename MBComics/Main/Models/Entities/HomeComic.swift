//
//  HomeComic.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

struct HomeComic: Comic {

    var poster: String
    var title: String
    var issueName: String
    var url: String
    var issueUrl: String
    var id: Int
    var numberIssues = 0

    init(_ json: JSON) {
        poster = json["img"].stringValue
        title = json["title"].stringValue
        issueName = json["issue_name"].stringValue
        url = json["url"].stringValue
        issueUrl = json["issue_url"].stringValue
        id = json["id"].intValue
    }
}
