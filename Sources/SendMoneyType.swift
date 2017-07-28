//
//  SendMoneyType.swift
//  Papara
//
//  Created by Mehmet Salih Aslan on 27/07/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation

public enum SendMoneyType {
    case email(String)
    case mobile(String)
    case paparaNumber(Int64)
    
    enum Validate {
        case error(Error)
        case valid([String: String])
    }
    
    func validate() -> Validate {
        switch self {
        case .email(let email):
            do {
                return Validate.valid(try SendMoneyValidation.validate(email: email))
            } catch let error {
                return Validate.error(error)
            }
        case .mobile(let phoneNumber):
            do {
                return Validate.valid(try SendMoneyValidation.validate(phoneNumber: phoneNumber))
            } catch let error {
                return Validate.error(error)
            }
        case .paparaNumber(let paparaNumber):
            do {
                return Validate.valid(try SendMoneyValidation.validate(paparaNumber: paparaNumber))
            } catch let error {
                return Validate.error(error)
            }
        }
    }
    
}
