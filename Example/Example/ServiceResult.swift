//
//  ServiceResult.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import ObjectMapper

class ServiceResult<T: Mappable>: Mappable {
    
    var data: T!
    var succeeded: Bool!
    var error: ServiceError!
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data                <- map["data"]
        succeeded           <- map["succeeded"]
        error               <- map["error"]
    }
    
}
