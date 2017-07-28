//
//  MerchantBalance.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import ObjectMapper

class MerchantBalance: Mappable {
    
    var id: String!
    var createdAt: String!
    var currency: Int!
    var totalBalance: Double!
    var lockedBalance: Double!
    var availableBalance: Double!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id                      <- map["id"]
        createdAt               <- map["createdAt"]
        currency                <- map["currency"]
        totalBalance            <- map["totalBalance"]
        lockedBalance           <- map["lockedBalance"]
        availableBalance        <- map["availableBalance"]
    }
    
}
