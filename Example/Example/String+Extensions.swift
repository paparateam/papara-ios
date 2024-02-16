//
//  String+Extensions.swift
//  Example
//
//  Created by Cemal Bayrı on 15.02.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "Localizable")
    }
}
