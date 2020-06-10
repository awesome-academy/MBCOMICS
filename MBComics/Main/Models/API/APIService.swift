//
//  APIManager.swift
//  MBComics
//
//  Created by HoaPQ on 5/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

typealias FullCompletion = (_ status: Bool, _ error: ErrorResponse?, _ json: JSON?) -> Void

enum APIType {
    case normal, loadMore, refresh
}

struct APIService {
    static let shared = APIService()
    
    fileprivate init() {
        let config = ApiConfig().baseUrl(AppUrl.baseUrl)
        ApiBase.config(config)
    }
    
    func request(urlString: String? = nil,
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
            var error: ErrorResponse?
            if !status {
                if let json = json {
                    error = ErrorResponse(json["error"])
                } else {
                    error = ErrorResponse(name: ErrorMessage.defaultTitle,
                                          message: ErrorMessage.defaultError,
                                          type: .noInternet)
                }
                
                completion?(status, error, json)
            } else {
                completion?(status, nil, json)
            }
        }
    }
}
