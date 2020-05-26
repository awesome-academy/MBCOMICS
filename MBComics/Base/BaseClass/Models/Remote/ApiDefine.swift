//
//  ApiDefine.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import SwiftyJSON
import Kingfisher

// Completion closure
typealias DataCompletion = (_ code: Int?, _ data: Data?) -> ()
typealias JSONCompletion = (_ code: Int?, _ json: JSON?) -> ()
typealias Completion = (_ status: Bool, _ code: Int?, _ json: JSON?) -> ()
typealias HTMLStringCompletion = (_ stringHTML: String?) -> ()

// HTTP method
enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

// Builder Config
class ApiConfig {
    var timeout: TimeInterval = 10
    var baseUrl = ""
    
    func baseUrl(_ baseUrl: String) -> ApiConfig {
        self.baseUrl = baseUrl
        return self
    }
    
    func timeout(_ timeout: Double) -> ApiConfig {
        self.timeout = timeout
        return self
    }
}
