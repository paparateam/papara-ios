//
//  Converter.swift
//  Papara
//
//  Created by Mehmet Salih Aslan on 19/01/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        return self.count
    }
    
    var toInt: Int {
        return Int(self)!
    }
    
    var toInt64: Int64 {
        return Int64(self)!
    }
    
    var toBool: Bool {
        return self == "1"
    }
    
    var toDouble: Double {
        return Double(self)!
    }
}

extension Int {
    
    var toString: String {
        return String(self)
    }
    
}

extension Double {
    
    var toString: String {
        return String(self)
    }
    
}

extension Int64 {
    
    var toString: String {
        return String(self)
    }
    
}
