//
//  Transaction+CoreDataProperties.swift
//  RSTask12
//
//  Created by Ivan Budovich on 10/4/21.
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
    @NSManaged public var wallet: Wallet?

}

extension Transaction : Identifiable {

}
