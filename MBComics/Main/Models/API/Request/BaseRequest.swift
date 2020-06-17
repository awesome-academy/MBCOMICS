//
//  BaseRequest.swift
//  MBComics
//
//  Created by HoaPQ on 6/17/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

class BaseRequest: NSObject {
    
    var url = ""
    var requestType = HTTPMethod.get
    var header: [String: String]?
    var body: [String: Any]?
    
    init(url: String) {
        super.init()
        self.url = url
    }
    
    init(url: String, requestType: HTTPMethod) {
        super.init()
        self.url = url
        self.requestType = requestType
    }
    
    init(url: String, requestType: HTTPMethod, header: [String: String]?) {
        super.init()
        self.url = url
        self.requestType = requestType
        self.header = header
    }
    
    init(url: String, requestType: HTTPMethod, header: [String: String]?, body: [String: Any]?) {
        super.init()
        self.url = url
        self.requestType = requestType
        self.header = header
        self.body = body
    }
}
