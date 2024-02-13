//
//  ServiceError.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

struct ServiceError: Codable, Error {
    let code: Int?
    let message: String?
}

