//
//  ErrorResponse.swift
//  MBComics
//
//  Created by HoaPQ on 5/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON
import Then

enum ErrorType {
    case noInternet, dataUnavailable
}

struct ErrorResponse: Error, Then {
    var name: String
    var message: String
    var type = ErrorType.dataUnavailable
    
    init (name: String, message: String, type: ErrorType) {
        self.name = name
        self.message = message
        self.type = type
    }
    
    init(_ json: JSON) {
        self.name = json["name"].string ?? ErrorMessage.defaultTitle
        self.message = json["message"].string ?? ErrorMessage.defaultError
    }
}
