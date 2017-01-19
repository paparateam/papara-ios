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
        static var Message : String = NSLocalizedString("AppNotFound.Message", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
        static var Install : String = NSLocalizedString("AppNotFound.Install", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
        static var Cancel : String = NSLocalizedString("AppNotFound.Cancel", tableName: nil, bundle: Papara.bundle(), value: "", comment: "")
    }
    
}
