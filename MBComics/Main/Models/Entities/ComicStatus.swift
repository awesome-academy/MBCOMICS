//
//  ComicStatus.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

enum ComicStatus: String {
    case completed = "completed"
    case onGoing = "ongoing"
}

extension ComicStatus {
    var stringValue: String {
        get {
            switch self {
            case .completed:
                return "Completed"
            default:
                return "On Going"
            }
        }
    }
}
