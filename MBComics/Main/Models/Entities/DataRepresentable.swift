//
//  DataRepresentable.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

// For saving data to firebase
protocol DatabaseRepresentable {
  var representation: [String: Any] { get }
}
