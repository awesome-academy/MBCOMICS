//
//  Constants.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Kingfisher

// Screen size
public let kScreenWidth = UIScreen.main.bounds.size.width
public let kScreenHeight = UIScreen.main.bounds.size.height

// Collection View Cell size
public let kCLCellWidth = 140
public let kCLCellHeight = 180
public let kCLCellHeight2 = 150

// Userdefaults keys
public let kUserInfo = "kUserInfo"

// Kingfisher Request Modifyer
public let kKfModifier = AnyModifier { request in
    var result = request
    // replace "Access-Token" with the field name you need, it's just an example
    result.setValue("https://readcomicsonline.me", forHTTPHeaderField: "comicpunch.net")
    return result
}

// Home View Controller Indexpaths
enum HomeCellIndex: Int, CaseIterable {
    case popularIndex = 0
    case newestIndex = 1
}

// User View Controller Indexpaths
enum UserCellIndex: Int, CaseIterable {
    case userInfoIndex = 0
    case favoriteIndex = 1
}

// Detail Comic
enum DetailCellIndex: Int, CaseIterable {
    case headerIndex = 0
    case summaryIndex = 1
    case reviewIndex = 2
    case infoIndex = 3
    case relatedIndex = 4
}

// Message
enum ErrorMessage {
    static let defaultTitle = "Error"
    static let noInternet = "No internet connection"
    static let defaultError = "Something failed, please try again!"
}

// Comic Info
enum ComicInfo {
    static let author = "Author"
    static let category = "Category"
    static let publisher = "Publisher"
    static let year = "Year"
    static let status = "Status"
    static let numberIssues = "Number of chapter"
    static let contactUs = "Contact Us"
    static let email = "hoapq.4398@gmail.com"
}

// Review
enum ReviewField {
    static let ratePoint = "rate_point"
    static let content = "content"
    static let contentPlaceholder = "Write your review"
    static let ratePointIndex = 0
    static let contentIndex = 1
    static let totalFields = 2
}

enum ListReview {
    static let totalSections = 2
    static let statsSection = 0
    static let reviewsSection = 1
}

// Reading screen
let kErrorPlaceHolderImage = UIImage.fontAwesomeIcon(name: .exclamationTriangle,
                                                     style: .regular,
                                                     textColor: .darkGray,
                                                     size: CGSize(width: 500, height: 500))
