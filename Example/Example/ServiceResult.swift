//
//  ServiceResult.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

struct ServiceResult<T: Codable>: Codable {
    let data: T?
    let succeeded: Bool?
    let error: ServiceError?
}
