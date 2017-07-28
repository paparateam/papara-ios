//
//  Merchant.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import ObjectMapper

class Merchant: Mappable {
    
    var legalName: String!
    var brandName: String!
    var balances: [MerchantBalance]!
    var allowedPaymentTypes: [AllowedPaymentTypes]!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        legalName               <- map["legalName"]
        brandName               <- map["brandName"]
        balances                <- map["balances"]
        allowedPaymentTypes     <- map["allowedPaymentTypes"]
    }
    
}
