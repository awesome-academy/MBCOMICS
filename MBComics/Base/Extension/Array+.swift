//
//  Array+.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjects(_ objects: [Element]) {
        for obj in objects {
            if let index = self.firstIndex(of: obj) {
                self.remove(at: index)
            }
        }
    }
}

extension BidirectionalCollection where Element: StringProtocol {
    var sentence: String {
        guard let last = last else { return "" }
        return count <= 2 ? joined(separator: " and ") :
            dropLast().joined(separator: ", ") + ", and " + last
    }
}
