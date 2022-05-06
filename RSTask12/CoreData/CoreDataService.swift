//
//  CoreDataService.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import Foundation
import CoreData
import Firebase
import FirebaseAuth

protocol CoreDataServiceType {
    
    func fetchWallets() -> [WalletInfo]
    func fetchTransactions(wallet: WalletInfo) -> [TransactionInfo]
    
    func doesWalletTitleExist(walletInfo: WalletInfo) -> Bool
    
    func totalBalance(for wallet: WalletInfo) -> Decimal
    func lastChangeDate(for wallet: WalletInfo) -> Date?
    
    func addNewWallet(walletInfo: WalletInfo, withUpdate: Bool)
    func addTransaction(transactionInfo: TransactionInfo, in wallet: WalletInfo, withUpdate: Bool)
    
    func changeWallet(walletInfo: WalletInfo)
    func changeTransaction(transactionInfo: TransactionInfo)
    
    
    func wallet(with id: NSManagedObjectID) -> WalletInfo?
    func transaction(with id: NSManagedObjectID) -> TransactionInfo?
    
    func deleteWallet(with id: NSManagedObjectID)
    func deleteTransaction(transaction: TransactionInfo, from wallet: WalletInfo)
    
    func clearAll(completion: @escaping ()->())
    func saveContext()
    
    func changeForToday()
    
    var firebaseService: FirebasePersistanceService! { get }
}


final class CoreDataService: NSObject, CoreDataServiceType {

    
    let managedObjectContext: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    let viewContext: NSManagedObjectContext
    var firebaseService: FirebasePersistanceService!
    
    
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
    
    func addNewWallet(walletInfo: WalletInfo, withUpdate: Bool)  {
        let wallet = Wallet(context: self.managedObjectContext)
        wallet.title = walletInfo.title
        wallet.currencyCode = walletInfo.currencyCode
        wallet.colorTheme = walletInfo.theme
        wallet.transactions = []
        wallet.user = Firebase.Auth.auth().currentUser?.uid ?? ""
        saveContext()
        if withUpdate {
            firebaseService.addWallet(walletInfo: walletInfo)
        }
    }
    
    func addTransaction(transactionInfo: TransactionInfo, in wallet: WalletInfo, withUpdate: Bool) {
        guard let id = wallet.id, let wallet = managedObjectContext.object(with: id) as? Wallet else { return }
        let transaction = Transaction(context: self.managedObjectContext)
        transaction.wallet = wallet
        transaction.walletId = wallet.title
        transaction.change = NSDecimalNumber(decimal: transactionInfo.change)
        transaction.category = transactionInfo.category.rawValue
        transaction.date = transactionInfo.date
        transaction.title = transactionInfo.title
        transaction.note = transactionInfo.note
        transaction.isOutcome = transactionInfo.isOutcome
        wallet.addToTransactions(transaction)
        saveContext()
        if withUpdate {
            firebaseService.addTransaction(transaction: transactionInfo)
        }
    }
    
    func deleteTransaction(transaction: TransactionInfo, from wallet: WalletInfo) {
        guard let id = transaction.id, let transactionModel = managedObjectContext.object(with: id) as? Transaction, let walletID = wallet.id, let wallet = managedObjectContext.object(with: walletID) as? Wallet else {return}
        wallet.removeFromTransactions(transactionModel)
        saveContext()
        firebaseService.deleteTransaction(transaction: transaction)
    }
    
    func changeWallet(walletInfo: WalletInfo) {
        guard let id = walletInfo.id, let wallet = managedObjectContext.object(with: id) as? Wallet else { return }
        wallet.currencyCode = walletInfo.currencyCode
        wallet.title = walletInfo.title
        wallet.colorTheme = walletInfo.theme
        saveContext()
        firebaseService.updateWallet(walletInfo: walletInfo)
    }
    
    func changeTransaction(transactionInfo: TransactionInfo) {
        guard let id = transactionInfo.id, let transaction = managedObjectContext.object(with: id) as? Transaction else { return }
        transaction.isOutcome = transactionInfo.isOutcome
        transaction.change = NSDecimalNumber(decimal: transactionInfo.change)
        transaction.note = transactionInfo.note
        transaction.title = transactionInfo.title
        transaction.category = transactionInfo.category.rawValue
        saveContext()
        firebaseService.updateTransaction(transaction: transactionInfo)
    }
    
    
    
    func wallet(with id: NSManagedObjectID) -> WalletInfo? {
        (managedObjectContext.object(with: id) as? Wallet)?.walletInfo
    }
    
    func transaction(with id: NSManagedObjectID) -> TransactionInfo? {
        (managedObjectContext.object(with: id) as? Transaction)?.transactionInfo
    }
    
    func deleteWallet(with id: NSManagedObjectID) {
        if let wallet = wallet(with: id) {
            firebaseService.deleteWallet(walletInfo: wallet)
        }
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
        viewContext = persistentContainer.viewContext
        super.init()
        self.firebaseService = .init(service: self)
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
    
    func clearAll(completion: @escaping ()->()) {
        func deleteAllData(_ entity:String) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try viewContext.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    viewContext.delete(objectData)
                }
            } catch let error {
                print("Detele all data in \(entity) error :", error)
            }
        }
        deleteAllData("Wallet")
        deleteAllData("Transaction")
        try? viewContext.save()
        completion()
    }
    
    func changeForToday()  {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
       let fromPredicate = NSPredicate(format: "%@ >= %K", dateFrom as NSDate, #keyPath(Transaction.date))
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Transaction.date), dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        //fetchRequest.predicate = datePredicate
        guard let transactions = try? managedObjectContext.fetch(fetchRequest) else {
            UserDefaults.init(suiteName: "group.budovich.task")?.set(nil, forKey: "WidgetInfo")
            return }
        
        let dict = Dictionary(grouping: transactions, by: \.wallet?.currencyCode)
        var newDict = [String: Double]()
        for (key, values) in dict {
            let value = values.reduce(into: 0.0, { if $1.isOutcome { $0 -= Double(truncating: $1.change) } else { $0 += Double(truncating: $1.change) } })
            if let key = key {
                newDict.updateValue(value, forKey: key)
            }
        }
    
        let parser = PropertyListEncoder()
        guard !newDict.isEmpty, let data = try? parser.encode(newDict) else {
            UserDefaults.init(suiteName: "group.budovich.task")?.set(nil, forKey: "WidgetInfo")
            return }
        UserDefaults.init(suiteName: "group.budovich.task")?.set(data, forKey: "WidgetInfo")
    }
    
}
