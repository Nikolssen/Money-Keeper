//
//  WalletEntity+CoreDataProperties.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//
//

import Foundation
import CoreData


extension WalletEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletEntity> {
        return NSFetchRequest<WalletEntity>(entityName: "WalletEntity")
    }

    @NSManaged public var colorTheme: Int32
    @NSManaged public var currencyCode: String?
    @NSManaged public var title: String?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var account: AcountEntity?

}

// MARK: Generated accessors for transactions
extension WalletEntity {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: TransactionEntity)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: TransactionEntity)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension WalletEntity : Identifiable {

}
