//
//  ServiceError.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import ObjectMapper

class ServiceError: Mappable {
    
    var code: Int!
    var message: String!
    
    init(message: String, code: Int) {
        self.message = message
        self.code = code
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
    }
}
