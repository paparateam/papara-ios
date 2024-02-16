//
//  BaseResponse.swift
//  Example
//
//  Created by Cemal Bayrı on 15.02.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let data: T?
    let succeeded: Bool
}
