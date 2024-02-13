//
//  WebService.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 23/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation
import Alamofire

protocol WebServiceProtocol {
    static func request<T: Codable>(request: Pay, success: @escaping (T) -> Void, failure: @escaping (ServiceError) -> Void)
}

struct WebService: WebServiceProtocol {
    
    static var apiUrl = "https://merchant.test.api.papara.com/"
    
    static func request<T: Codable>(request: Pay, success: @escaping (T) -> Void, failure: @escaping (ServiceError) -> Void) {
        
        let url = "\(apiUrl)\(request.path)"
        
        AF.request(url,
                   method: request.method,
                   parameters: request.dictionary,
                   encoding: JSONEncoding.default,
                   headers: ["ApiKey": "ApiKey123"])
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                guard let responseData = try? JSONDecoder().decode(T.self, from: data) else {
                    failure(ServiceError(code: -1, message: "Decoding error"))
                    return
                }
                success(responseData)
            case .failure(let error):
                guard let data = response.data,
                      let decodedError = try? JSONDecoder().decode(ServiceError.self, from: data) else {
                    failure(ServiceError(code: error.responseCode ?? .zero, message: error.localizedDescription))
                    return
                }
                
                failure(decodedError)
            }
        }
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
