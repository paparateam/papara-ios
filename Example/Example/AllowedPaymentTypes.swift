//
//  AllowedPaymentTypes.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import ObjectMapper

class AllowedPaymentTypes: Mappable {
    
    var id: Int!
    var createdAt: String!
    var paymentMethod: Int!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id                      <- map["id"]
        createdAt               <- map["createdAt"]
        paymentMethod           <- map["paymentMethod"]
    }
    
}
