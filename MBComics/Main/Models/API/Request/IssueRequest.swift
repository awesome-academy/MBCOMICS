//
//  IssueRequest.swift
//  MBComics
//
//  Created by HoaPQ on 6/17/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

class IssueRequest: BaseRequest {
    required init(issueId: String) {
        super.init(url: AppUrl.issueUrl,
                   requestType: .get,
                   header: nil,
                   body: ["id": issueId])
    }
}
