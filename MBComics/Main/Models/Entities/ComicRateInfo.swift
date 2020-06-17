//
//  ComicRateInfo.swift
//  MBComics
//
//  Created by HoaPQ on 6/14/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import FirebaseDatabase

struct ComicRateInfo {
    let ratePoint: Double
    let rateCount: Int
    let comicId: Int
    
    init(_ comicId: Int, _ ratePoint: Double, _ rateCount: Int) {
        self.ratePoint = ratePoint
        self.rateCount = rateCount
        self.comicId = comicId
    }
    
    init?(_ snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        
        guard let comicId = Int(snapshot.key),
              let ratePoint = dict["rate_point"] as? Double,
              let rateCount = dict["rate_count"] as? Int
              else { return nil }
        
        self.comicId = comicId
        self.ratePoint = ratePoint
        self.rateCount = rateCount
    }
}

extension ComicRateInfo: DatabaseRepresentable {
    var representation: [String: Any] {
        return ["rate_point": ratePoint.roundToPlaces(1),
                "rate_count": rateCount]
    }
}
