//
//  PaparaResult.swift
//  Papara
//
//  Created by Mehmet Salih Aslan on 11/11/2016.
//  Copyright © 2016 Mobillium. All rights reserved.
//

import Foundation

public enum SendMoneyResult {
    case success
    case cancel
    case fail(error: Error)
}

public enum PayResult {
    case success(paymentId: String, referenceId: String, status: Int, amount: Double)
    case cancel
    case fail(error: Error)
}

public enum PaparaNumberResult {
    case success(paparaNumber: Int64)
    case cancel
    case fail(error: Error)
}
