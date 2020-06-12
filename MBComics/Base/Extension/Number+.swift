//
//  Number+.swift
//  MBComics
//
//  Created by HoaPQ on 6/10/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

extension Double {
    func roundToPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func cutOffDecimalsAfter(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.towardZero) / divisor
    }
}
