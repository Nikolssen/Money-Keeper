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
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension WalletEntity {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: TransactionEntity)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: TransactionEntity)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

extension WalletEntity : Identifiable {

}
