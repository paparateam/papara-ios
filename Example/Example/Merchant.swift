//
//  Merchant.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

struct Merchant: Codable {
    let legalName: String?
    let brandName: String?
    let balances: [MerchantBalance]?
    let allowedPaymentTypes: [AllowedPaymentTypes]?
}
