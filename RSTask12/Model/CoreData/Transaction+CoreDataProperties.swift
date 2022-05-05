//
//  Transaction+CoreDataProperties.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/2/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var category: Int32
    @NSManaged public var change: NSDecimalNumber
    @NSManaged public var date: Date
    @NSManaged public var isOutcome: Bool
    @NSManaged public var note: String?
    @NSManaged public var title: String
    @NSManaged public var user: String
    @NSManaged public var walletId: String
    @NSManaged public var wallet: Wallet?

}

extension Transaction : Identifiable {

}
