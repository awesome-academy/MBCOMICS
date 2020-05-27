//
//  ErrorResponse.swift
//  MBComics
//
//  Created by HoaPQ on 5/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

struct ErrorResponse: Error {
    var name: String?
    var message: String?
    
    init() { }
    
    init(_ json: JSON) {
        self.name = json["name"].string
        self.message = json["message"].string
    }
}
