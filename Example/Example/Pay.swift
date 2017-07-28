//
//  Pay.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import ObjectMapper
import Alamofire

class Pay: Mappable {
    
    let httpMethod = HTTPMethod.post
    let path = "payments"
    
    var amount: Double!
    var referenceId = "123456789"
    var orderDescription = "Test payment"
    var notificationUrl = "https://www.paparamerchant.com/ipn"
    var redirectUrl = "http://www.mobillium.com/"
    
    init(amount: Double) {
        self.amount = amount
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        amount              <- map["amount"]
        referenceId         <- map["referenceId"]
        orderDescription    <- map["orderDescription"]
        notificationUrl     <- map["notificationUrl"]
        redirectUrl         <- map["redirectUrl"]
    }
}
