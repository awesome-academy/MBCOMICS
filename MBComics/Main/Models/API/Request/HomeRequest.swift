//
//  HomeRequest.swift
//  MBComics
//
//  Created by HoaPQ on 6/17/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

class HomeRequest: BaseRequest {
    required init() {
        super.init(url: AppUrl.homeUrl)
    }
}
