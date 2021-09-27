//
//  TransactionEntity+CoreDataProperties.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isOutcome: Bool
    @NSManaged public var change: Int64
    @NSManaged public var category: Int32

}

extension TransactionEntity : Identifiable {

}
