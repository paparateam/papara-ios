//
//  MerchantBalance.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

struct MerchantBalance: Codable {
    let id: String?
    let createdAt: String?
    let currency: Int?
    let totalBalance: Double?
    let lockedBalance: Double?
    let availableBalance: Double?
}
