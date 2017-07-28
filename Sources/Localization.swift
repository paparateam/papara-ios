//
//  Localization.swift
//  Papara
//
//  Created by Utku Yildirim on 19/01/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation

struct Localization {
    
    struct AppNotFound {
        static var Title : String = NSLocalizedString("AppNotFound.Title", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
        struct Message {
            static var PaparaNumber : String = NSLocalizedString("AppNotFound.Message.PaparaNumber", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
            static var SendMoney : String = NSLocalizedString("AppNotFound.Message.SendMoney", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
            static var Pay : String = NSLocalizedString("AppNotFound.Message.Pay", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
        }
        static var Install : String = NSLocalizedString("AppNotFound.Install", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
        static var Cancel : String = NSLocalizedString("AppNotFound.Cancel", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
        static var Continue : String = NSLocalizedString("AppNotFound.Continue", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
    }
    
    struct Error {
        static var Unexpected : String = NSLocalizedString("Error.Unexpected", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
        struct Wrong {
            static var Email : String = NSLocalizedString("Error.Wrong.Email", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
            static var PaparaNumber : String = NSLocalizedString("Error.Wrong.PaparaNumber", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
            static var PhoneNumber : String = NSLocalizedString("Error.Wrong.PhoneNumber", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
        }
    }
    
}
