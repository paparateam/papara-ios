//
//  NSURL.swift
//  Papara
//
//  Created by Utku Yildirim on 19/01/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation

extension NSURL {
    var queryItems: [String: String]? {
        var params = [String: String]()
        return NSURLComponents(URL: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], combine: { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            })
    }
}
