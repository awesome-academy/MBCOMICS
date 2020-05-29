//
//  Comic.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

protocol Comic {
    var id: Int { get set }
    var title: String { get set }
    var poster: String { get set }
    var numberIssues: Int { get set }
}
