//
//  DetailRequest.swift
//  MBComics
//
//  Created by HoaPQ on 6/17/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

class DetailRequest: BaseRequest {
    required init (comicId: Int) {
        super.init(url: AppUrl.comicUrl,
                   requestType: .get,
                   header: nil,
                   body: ["id": comicId])
    }
}
