//
//  Wallet.swift
//  RSTask12
//
//  Created by Admin on 26.09.2021.
//

import Foundation
import CoreData

struct WalletInfo {
    var theme: ColorTheme
    var currencyCode: String
    var title: String
    var id: NSManagedObjectID?
}

extension Wallet {
    
    var walletInfo: WalletInfo {
        WalletInfo(theme: ColorTheme(rawValue: colorTheme)!, currencyCode: currencyCode, title: title, id: objectID)
    }
}
