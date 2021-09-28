//
//  Currency.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/28/21.
//

import Foundation
enum Currency {
    static var currencies: [String] {
        Locale.commonISOCurrencyCodes
    }
    
    static func symbol(for code: String) -> String {
        NSLocale(localeIdentifier: Locale.current.identifier).displayName(forKey: .currencySymbol, value: code) ?? code
    }
    static func name(for code: String) -> String {
        Locale.current.localizedString(forCurrencyCode: code) ?? code
    }
}
