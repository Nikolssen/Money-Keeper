//
//  Currency.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/28/21.
//

import Foundation
enum Currency {
    static fileprivate var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.locale = .current
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }()
    
    static var currencies: [String] {
        Locale.commonISOCurrencyCodes
    }
    
    static func symbol(for code: String) -> String? {
        NSLocale(localeIdentifier: Locale.current.identifier).displayName(forKey: .currencySymbol, value: code)
    }
    static func name(for code: String) -> String {
        Locale.current.localizedString(forCurrencyCode: code) ?? code
    }
    
    static var localCurrencyCode: String {
        Locale.current.currencyCode ?? "USD"
    }
    
    static func currencyFormat(for number: Decimal, code: String) -> String {
        let numberFormatter = Currency.numberFormatter
        if let symbol = Currency.symbol(for: code) {
            numberFormatter.currencySymbol = symbol
        }
        else  {
            numberFormatter.currencyCode = code
        }
        return numberFormatter.string(from: NSDecimalNumber(decimal: number)) ?? ""  
    }
}
