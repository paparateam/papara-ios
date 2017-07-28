//
//  SendMoneyValidation.swift
//  Papara
//
//  Created by Mehmet Salih Aslan on 27/07/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation

public class SendMoneyValidation {
    
    static func validate(email: String) throws -> [String : String] {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        if emailTest.evaluate(with: email) {
            return ["receiver": email, "sendMoneyType": "0"]
        } else {
            throw NSError(domain: Papara.shared.domain, code: 0, userInfo: ["localizedDescription": Localization.Error.Wrong.Email])
        }
    }
    
    static func validate(phoneNumber: String) throws -> [String : String] {
        if phoneNumber.hasPrefix("+") {
            return ["receiver": phoneNumber, "sendMoneyType": "1"]
        } else {
            throw NSError(domain: Papara.shared.domain, code: 0, userInfo: ["localizedDescription": Localization.Error.Wrong.PhoneNumber])
        }
    }
    
    static func validate(paparaNumber: Int64) throws -> [String : String] {
        if paparaNumber.toString.length == 10 {
            return ["receiver": paparaNumber.toString, "sendMoneyType": "2"]
        } else {
            throw NSError(domain: Papara.shared.domain, code: 0, userInfo: ["localizedDescription": Localization.Error.Wrong.PaparaNumber])
        }
    }
    
}
