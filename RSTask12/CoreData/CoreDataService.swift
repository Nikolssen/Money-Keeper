//
//  CoreDataService.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import Foundation
import CoreData

protocol CoreDataServiceType {
    
    func fetchWallets() -> [WalletInfo]
    func fetchTransactions(wallet: WalletInfo) -> [TransactionInfo]
    
    func doesWalletTitleExist(walletInfo: WalletInfo) -> Bool
    
    func totalBalance(for wallet: WalletInfo) -> Decimal
    func lastChangeDate(for wallet: WalletInfo) -> Date?
    
    func addNewWallet(walletInfo: WalletInfo)
    func addTransaction(transactionInfo: TransactionInfo, in wallet: WalletInfo)
    
    func changeWallet(walletInfo: WalletInfo)
    func changeTransaction(transactionInfo: TransactionInfo)
    
    
    func wallet(with id: NSManagedObjectID) -> WalletInfo?
    func transaction(with id: NSManagedObjectID) -> TransactionInfo?
    
    func deleteWallet(with id: NSManagedObjectID)
    func deleteTransaction(transaction: TransactionInfo, from wallet: WalletInfo)
    
    
    
    func saveContext()
}


final class CoreDataService: NSObject, CoreDataServiceType {
    
    let managedObjectContext: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    
    
    
    func doesWalletTitleExist(walletInfo: WalletInfo) -> Bool {
        let fetchRequest = NSFetchRequest<Wallet>(entityName: "Wallet")
        fetchRequest.predicate = NSPredicate(format: "title == %@", walletInfo.title)
        let result = try? managedObjectContext.fetch(fetchRequest)
        if let result = result {
            if result.isEmpty {
                return false
            }
            else {
                if result.count > 1 {
                    return true
                }
                if result.first!.objectID.isEqual(walletInfo.id) {
                    return false
                }
                else {
                    return true
                }
            }
        }
        return false
    }
    
    func fetchWallets() -> [WalletInfo] {
        let wallets: [Wallet]? = try? managedObjectContext.fetch(Wallet.fetchRequest())
        return wallets?.map{$0.walletInfo} ?? []
    }
    
    func fetchTransactions(wallet: WalletInfo) -> [TransactionInfo] {
        guard let id = wallet.id, let wallet = managedObjectContext.object(with: id) as? Wallet, let transactions = wallet.transactions?.array as? [Transaction] else { return [] }
        return transactions.map({$0.transactionInfo}).sorted(by: {$0.date > $1.date})
    }
    
    
    func totalBalance(for wallet: WalletInfo) -> Decimal {
        guard let id = wallet.id, let wallet = managedObjectContext.object(with: id) as? Wallet, let transactions = wallet.transactions?.array as? [Transaction] else {return 0}
        var balance: Decimal = 0
        for transaction in transactions {
            if transaction.isOutcome {
                balance -= transaction.change.decimalValue
            }
            else {
                balance += transaction.change.decimalValue
            }
        }
        return balance
        
    }
    
    func lastChangeDate(for wallet: WalletInfo) -> Date? {
        guard let id = wallet.id, let wallet = managedObjectContext.object(with: id) as? Wallet, let transactions = wallet.transactions else {return nil}
        var date: Date? = nil
        for transaction in transactions {
            if let transaction = transaction as? Transaction {
                if date == nil {
                    date = transaction.date
                }
                else {
                    if let newDate = date, newDate > transaction.date {
                        date = transaction.date
                    }
                }
            }
        }
        return date
    }
    
    func addNewWallet(walletInfo: WalletInfo)  {
        let wallet = Wallet(context: self.managedObjectContext)
        wallet.title = walletInfo.title
        wallet.currencyCode = walletInfo.currencyCode
        wallet.colorTheme = walletInfo.theme.rawValue
        wallet.transactions = []
        saveContext()
    }
    
    func addTransaction(transactionInfo: TransactionInfo, in wallet: WalletInfo) {
        guard let id = wallet.id, let wallet = managedObjectContext.object(with: id) as? Wallet else { return }
        let transaction = Transaction(context: self.managedObjectContext)
        transaction.wallet = wallet
        transaction.change = NSDecimalNumber(decimal: transactionInfo.change)
        transaction.category = transactionInfo.category.rawValue
        transaction.date = transactionInfo.date
        transaction.title = transactionInfo.title
        transaction.note = transactionInfo.note
        transaction.isOutcome = transactionInfo.isOutcome
        wallet.addToTransactions(transaction)
        saveContext()
    }
    
    func deleteTransaction(transaction: TransactionInfo, from wallet: WalletInfo) {
        guard let id = transaction.id, let transaction = managedObjectContext.object(with: id) as? Transaction, let walletID = wallet.id, let wallet = managedObjectContext.object(with: walletID) as? Wallet else {return}
        wallet.removeFromTransactions(transaction)
        saveContext()
    }
    
    func changeWallet(walletInfo: WalletInfo) {
        guard let id = walletInfo.id, let wallet = managedObjectContext.object(with: id) as? Wallet else { return }
        wallet.currencyCode = walletInfo.currencyCode
        wallet.title = walletInfo.title
        wallet.colorTheme = walletInfo.theme.rawValue
        saveContext()
    }
    
    func changeTransaction(transactionInfo: TransactionInfo) {
        guard let id = transactionInfo.id, let transaction = managedObjectContext.object(with: id) as? Transaction else { return }
        transaction.isOutcome = transactionInfo.isOutcome
        transaction.change = NSDecimalNumber(decimal: transactionInfo.change)
        transaction.note = transactionInfo.note
        transaction.title = transactionInfo.title
        transaction.category = transactionInfo.category.rawValue
        saveContext()
    }
    
    
    
    func wallet(with id: NSManagedObjectID) -> WalletInfo? {
        (managedObjectContext.object(with: id) as? Wallet)?.walletInfo
    }
    
    func transaction(with id: NSManagedObjectID) -> TransactionInfo? {
        (managedObjectContext.object(with: id) as? Transaction)?.transactionInfo
    }
    
    func deleteWallet(with id: NSManagedObjectID) {
        managedObjectContext.delete(managedObjectContext.object(with: id))
        saveContext()
    }
    
    init(containerName: String) {
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        managedObjectContext = persistentContainer.newBackgroundContext()
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
