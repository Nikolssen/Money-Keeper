//
//  AcountEntity+CoreDataProperties.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//
//

import Foundation
import CoreData


extension AcountEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AcountEntity> {
        return NSFetchRequest<AcountEntity>(entityName: "AcountEntity")
    }

    @NSManaged public var wallets: NSSet?

}

// MARK: Generated accessors for wallets
extension AcountEntity {

    @objc(addWalletsObject:)
    @NSManaged public func addToWallets(_ value: WalletEntity)

    @objc(removeWalletsObject:)
    @NSManaged public func removeFromWallets(_ value: WalletEntity)

    @objc(addWallets:)
    @NSManaged public func addToWallets(_ values: NSSet)

    @objc(removeWallets:)
    @NSManaged public func removeFromWallets(_ values: NSSet)

}

extension AcountEntity : Identifiable {

}
