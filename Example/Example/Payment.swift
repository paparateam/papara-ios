//
//  Payment.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import ObjectMapper

class Payment: Mappable {
    
    var userId: Int!
    var id: String!
    var createdAt: String!
    var merchant: Merchant!
    var paymentMethodDescription: String!
    var paymentMethod: Int!
    var referenceId: String!
    var orderDescription: String!
    var status: Int!
    var statusDescription: String!
    var amount: Double!
    var currency: Int!
    var notificationUrl: String!
    var notificationDone: Bool!
    var redirectUrl: String!
    var paymentUrl: String!
    var merchantSecretKey: String!
    var returningRedirectUrl: String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId                      <- map["userId"]
        id                          <- map["id"]
        createdAt                   <- map["createdAt"]
        merchant                    <- map["merchant"]
        paymentMethodDescription    <- map["paymentMethodDescription"]
        paymentMethod               <- map["paymentMethod"]
        referenceId                 <- map["referenceId"]
        orderDescription            <- map["orderDescription"]
        status                      <- map["status"]
        statusDescription           <- map["statusDescription"]
        amount                      <- map["amount"]
        currency                    <- map["currency"]
        notificationUrl             <- map["notificationUrl"]
        notificationDone            <- map["notificationDone"]
        redirectUrl                 <- map["redirectUrl"]
        paymentUrl                  <- map["paymentUrl"]
        merchantSecretKey           <- map["merchantSecretKey"]
        returningRedirectUrl        <- map["returningRedirectUrl"]
    }
    
}
