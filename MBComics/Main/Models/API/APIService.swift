//
//  APIManager.swift
//  MBComics
//
//  Created by HoaPQ on 5/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import SwiftyJSON

typealias FullCompletion = (_ error: ErrorResponse?, _ json: JSON?) -> Void

enum APIType {
    case normal, loadMore, refresh
}

struct APIService {
    static let shared = APIService()
    
    fileprivate init() {
        let config = ApiConfig().baseUrl(AppUrl.baseUrl)
        ApiBase.config(config)
    }
    
    func request(input: BaseRequest, completion: FullCompletion?) {
        ApiBase.shared.request(urlString: input.url,
                               httpMethod: input.requestType,
                               header: input.header,
                               param: input.body,
                               body: nil) { (status, _, json) in
            var error: ErrorResponse?
            if !status {
                if let json = json {
                    error = ErrorResponse(json["error"])
                } else {
                    error = ErrorResponse(name: ErrorMessage.defaultTitle,
                                          message: ErrorMessage.defaultError,
                                          type: .noInternet)
                }
                
                completion?(error, nil)
            } else {
                completion?(nil, json)
            }
        }
    }
}
