//
//  WebService.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Alamofire
import ObjectMapper

class WebService {
    
    static var apiUrl = "https://merchant.test.api.papara.com/"
    
    class func request<T: Mappable>(request: Pay, success: @escaping (T) -> Void, failure: @escaping (ServiceError) -> Void) {
        
        let url = "\(apiUrl)\(request.path)"
        
        print("Parameters: \(String(describing: request.toJSON()))")
        
        
        Alamofire.request(url, method: request.httpMethod, parameters: request.toJSON(), encoding: JSONEncoding.default, headers: ["ApiKey": "ApiKey123"])
            .validate()
            .responseData(completionHandler: { (response) in
                if let value = response.result.value {
                    if let json = String(data: value, encoding: .utf8) {
                        print("\nResponse JSON: \(json)")
                    }
                }
            })
            .responseJSON { response in
                // Success
                if response.result.isSuccess {
                    
                    // JSON Data
                    if let result: ServiceResult<T> = Mapper<ServiceResult<T>>().map(JSON: response.result.value as! [String: Any]) {
                        if result.succeeded {
                            success(result.data)
                        } else {
                            failure(result.error)
                        }
                    }
                }
                
                // Failure
                if response.result.isFailure {
                    
                    if let value = response.data {
                        let responseData = String.init(data: value, encoding: String.Encoding.utf8)
                        
                        if let result = Mapper<ServiceError>().map(JSONString: responseData!) {
                            failure(result)
                            return
                        }
                        
                    }
                    
                    if let error = response.result.error {
                        failure(ServiceError(message: error.localizedDescription, code: -1))
                        return
                    }
                    
                }
        }
    }
    
}
