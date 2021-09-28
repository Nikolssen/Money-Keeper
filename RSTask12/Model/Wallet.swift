//
//  Wallet.swift
//  RSTask12
//
//  Created by Admin on 26.09.2021.
//

import Foundation

struct Wallet {
    var theme: ColorTheme
    var currencyCode: String
    var title: String
    var transactions: [Transaction]
}

extension Wallet {
    var viewModel: WalletCellViewModel {
        WalletCellViewModel(title: title, balance: "55", date: "55")
    }
}
