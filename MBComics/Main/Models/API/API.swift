//
//  APIManager.swift
//  MBComics
//
//  Created by HoaPQ on 5/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

typealias FullCompletion = (_ status: Bool, _ error: ErrorResponse?, _ json: JSON?) -> Void


class API {
    static let shared = API()
    
    fileprivate init() {
        let config = ApiConfig().baseUrl("https://mbcomic-app.herokuapp.com")
        ApiBase.config(config)
    }
    
    fileprivate func _request(urlString: String? = nil,
                 httpMethod: HTTPMethod,
                 header: [String: String]? = nil,
                 param: [String: Any]? = nil,
                 body: [String: Any]? = nil,
                 completion: FullCompletion?) {
        ApiBase.shared.request(urlString: urlString,
                               httpMethod: httpMethod,
                               header: header,
                               param: param,
                               body: body) { (status, code, json) in
            var error = ErrorResponse()
            if !status {
                if let json = json {
                    error = ErrorResponse(json["error"])
                    if error.message == nil {
                        error.name = "Error"
                        error.message = "Something failed, please try again!"
                    }
                } else {
                    error.name = "Error"
                    error.message = "No internet connection"
                }
                
                completion?(status, error, json)
            } else {
                completion?(status, nil, json)
            }
        }
    }
}
