//
//  Constants.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Kingfisher

// Screen size
public let kScreenWidth = UIScreen.main.bounds.size.width
public let kScreenHeight = UIScreen.main.bounds.size.height

// Collection View Cell size
public let kCLCellWidth = 140
public let kCLCellHeight = 180
public let kCLCellHeight2 = 150

// Kingfisher Request Modifyer
public let kKfModifier = AnyModifier { request in
    var r = request
    // replace "Access-Token" with the field name you need, it's just an example
    r.setValue("https://readcomicsonline.me", forHTTPHeaderField: "comicpunch.net")
    return r
}

// Home View Controller Indexpaths
public let kPopularIndexPath = 0
public let kNewestIndexPath = 1
public let kNumberHomeSections = 2

// Fake data (will remove later)
public let kComicJson = """
{
    "title": "Action Comics",
    "url": "/action-comics-2016",
    "img": "https://comicpunch.net/pics/gwkeem-001.jpg",
    "issue_url": "https://comicpunch.net/reader/Action-Comics-2016/Action-Comics-2016-Issue-1022",
    "issue_name": "Issue # 1022",
    "id": 974
}
"""
