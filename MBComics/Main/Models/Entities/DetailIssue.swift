//
//  DetailIssue.swift
//  MBComics
//
//  Created by HoaPQ on 6/17/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

struct DetailIssue {
    let id: String
    let title: String
    let images: [String]
    
    init(_ json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue
        images = json["img"].arrayObject as? [String] ?? []
    }
}
