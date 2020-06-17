//
//  SearchRequest.swift
//  MBComics
//
//  Created by HoaPQ on 6/17/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

class SearchRequest: BaseRequest {
    required init(query: String) {
        super.init(url: AppUrl.searchUrl,
                   requestType: .get,
                   header: nil,
                   body: ["q": query])
    }
}
