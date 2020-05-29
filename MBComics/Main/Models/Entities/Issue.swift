//
//  Issue.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

struct Issue {
    var id: String
    var title: String
    
    init(_ json: JSON) {
        id = json["_id"].stringValue
        title = json["title"].stringValue
    }
}
