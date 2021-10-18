//
//  Mock.swift
//  RSTask12Tests
//
//  Created by Ivan Budovich on 10/8/21.
//

import Foundation
@testable import RSTask12

class WalletListMockCoordinator: WalletListCoordinator {
    
    var didRequestColorTheme: Bool = false
    var didGoToNewWallet: Bool = false
    var didGoToWallet: Bool = false
    
    var colorTheme: ColorTheme {
        didRequestColorTheme = true
        return .aurora
    }
    
    func goToNewWallet() {
        didGoToNewWallet = true
    }
    
    func goToWallet(walletInfo: WalletInfo) {
        didGoToWallet = true
    }
    
    
}

class WalletSettingsMockCoordinator: WalletSettingsCoordinator {
    
    var didGoBack: Bool = false
    var didPopToList: Bool = false
    var didShowCurrencies: Bool = false
    var didShowColorTheme: Bool = false
    var didRequestColorTheme: Bool = false
    var didChangeColorTheme: Bool = false
    
    func goBack() {
        didGoBack = true
    }
    
    func popToWalletList() {
        didPopToList = true
    }
    
    func showCurrencies(code: String, callback: @escaping (String) -> Void) {
        didShowCurrencies = true
        callback("EUR")
    }
    
    func showColorThemes(callback: @escaping (ColorTheme) -> Void) {
        didShowColorTheme = true
        callback(.red)
    }
    
    var colorTheme: ColorTheme {
        get {
            didRequestColorTheme = true
            return .aurora
        }
        set {
            didChangeColorTheme = true
        }
    }
    
    
}

class CollectionMockCoordinator: CollectionCoordinator {
    var colorTheme: ColorTheme {
        didRequestColorTheme = true
        return .aurora
    }
    
    
    
    var didRequestColorTheme: Bool = false
    var didGoBack: Bool = false
    
    func goBack() {
        didGoBack = true
    }
    
}

class WalletMockCoordinator: WalletCoordinator {
    var didGoBack: Bool = false
    var didRequestColorTheme: Bool = false
    var didChangeColorTheme: Bool = false
    var didGoEditting: Bool = false
    var didGoToNewTransaction: Bool = false
    var didGoToAllTransaction: Bool = false
    var didShowTransaction: Bool = false
    
    var colorTheme: ColorTheme {
        get {
            didRequestColorTheme = true
            return .aurora
        }
        set {
            didChangeColorTheme = true
        }
    }
    
    func goBack() {
        didGoBack = true
    }
    
    func goEdit(wallet: WalletInfo) {
        didGoEditting = true
    }
    
    func goToNewTransaction(for wallet: WalletInfo) {
        didGoToNewTransaction = true
    }
    
    func goToAllTransaction(for wallet: WalletInfo) {
        didGoToAllTransaction = true
    }
    
    func showTransaction(for transaction: TransactionInfo, wallet: WalletInfo) {
        didShowTransaction = true
    }
    
}

class TransactionListMockCoordinator: TransactionListCoordinator {
    
    var didShowTransaction: Bool = false
    var didGoBack: Bool = false
    var didRequestColorTheme: Bool = false
    
    func showTransaction(for transaction: TransactionInfo, wallet: WalletInfo) {
        didShowTransaction = true
    }
    
    func goBack() {
        didGoBack = true
    }
    
    var colorTheme: ColorTheme {
        didRequestColorTheme = true
        return .aurora
    }
}

class TransactionSettingsMockCoordinator: TransactionSettingsCoordinator {
    var didGoToCategories: Bool = false
    var didGoBack: Bool = false
    var didRequestColorTheme: Bool = false
    
    func goToCategories(category: TransactionInfo.Category, callback: @escaping (TransactionInfo.Category) -> Void) {
        didGoToCategories = true
    }
    
    func goBack() {
        didGoBack = true
    }
    
    var colorTheme: ColorTheme {
        didRequestColorTheme = true
        return .aurora
    }
    
}

class TransactionMockCoordinator: TransactionCoordinator {
    var didGoToEdit: Bool = false
    var didGoBack: Bool = false
    var didRequestColorTheme: Bool = false
    
    func goToEdit(transactionInfo: TransactionInfo, wallet: WalletInfo) {
        didGoToEdit = false
    }
    
    func goBack() {
        didGoBack = false
    }
    
    var colorTheme: ColorTheme {
        didRequestColorTheme = true
        return .aurora
    }
    
    
}
