//
//  Payment.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

struct Payment: Codable {
    let userId: Int?
    let id: String?
    let createdAt: String?
    let merchant: Merchant?
    let paymentMethodDescription: String?
    let paymentMethod: Int?
    let referenceId: String?
    let orderDescription: String?
    let status: Int?
    let statusDescription: String?
    let amount: Double?
    let currency: Int?
    let notificationUrl: String?
    let notificationDone: Bool?
    let redirectUrl: String?
    let paymentUrl: String?
    let merchantSecretKey: String?
    let returningRedirectUrl: String?
}
