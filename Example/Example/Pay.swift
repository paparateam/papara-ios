//
//  Pay.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Alamofire

struct Pay: Codable {
    var httpMethod = "POST"
    var path = "payments"
    var amount: Double!
    var referenceId = "123456789"
    var orderDescription = "Test payment"
    var notificationUrl = "https://www.paparamerchant.com/ipn"
    var redirectUrl = "http://www.mobillium.com/"
    
    init(amount: Double) {
        self.amount = amount
    }
    
    var method: HTTPMethod {
        HTTPMethod(rawValue: httpMethod)
    }
}
