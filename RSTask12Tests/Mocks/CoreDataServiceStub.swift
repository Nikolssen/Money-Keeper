//
//  CoreDataServiceStub.swift
//  RSTask12Tests
//
//  Created by Ivan Budovich on 10/8/21.
//

import Foundation
import CoreData

@testable import RSTask12

class CoreDataServiceStub: CoreDataServiceType {
    
    var wallets = [WalletInfo(theme: .aurora, currencyCode: "EUR", title: "Salary", id: nil),
                   WalletInfo(theme: .green, currencyCode: "USD", title: "Dollars", id: nil)]
    
    var transactions = [TransactionInfo(title: "The title", date: Date(), isOutcome: true, change: 500, category: .clothes, note: nil, id: nil),
                        TransactionInfo(title: "New title", date: Date(), isOutcome: false, change: 600, category: .education, note: nil, id: nil)]
    
    func fetchWallets() -> [WalletInfo] {
        wallets
    }
    
    func fetchTransactions(wallet: WalletInfo) -> [TransactionInfo] {
        transactions
    }
    
    func doesWalletTitleExist(walletInfo: WalletInfo) -> Bool {
        wallets.contains(where: {$0.title == walletInfo.title})
    }
    
    func totalBalance(for wallet: WalletInfo) -> Decimal {
        transactions.reduce(Decimal(0), {$0 + $1.change * ($1.isOutcome ? -1 : +1)})
    }
    
    func lastChangeDate(for wallet: WalletInfo) -> Date? {
        return Date()
    }
    
    func addNewWallet(walletInfo: WalletInfo) {
        wallets.append(walletInfo)
    }
    
    func addTransaction(transactionInfo: TransactionInfo, in wallet: WalletInfo) {
        
    }
    
    func changeWallet(walletInfo: WalletInfo) {
        
    }
    
    func changeTransaction(transactionInfo: TransactionInfo) {
        
    }
    
    func wallet(with id: NSManagedObjectID) -> WalletInfo? {
        nil
    }
    
    func transaction(with id: NSManagedObjectID) -> TransactionInfo? {
        nil
    }
    
    func deleteWallet(with id: NSManagedObjectID) {
        
    }
    
    func deleteTransaction(transaction: TransactionInfo, from wallet: WalletInfo) {
        
    }
    
    func saveContext() {
        
    }
    
    
}
