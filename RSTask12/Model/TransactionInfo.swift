//
//  Transaction.swift
//  RSTask12
//
//  Created by Admin on 26.09.2021.
//

import UIKit
import CoreData

struct TransactionInfo {
    var title: String
    let date: Date
    var isOutcome: Bool
    var change: Decimal
    var category: TransactionInfo.Category
    var note: String?
    var id: NSManagedObjectID?
}

extension Transaction {
    var transactionInfo: TransactionInfo {
        TransactionInfo(title: title, date: date, isOutcome: isOutcome, change: change.decimalValue, category: TransactionInfo.Category(rawValue: category)!, note: note, id: objectID)
    }
}

extension TransactionInfo {
    
    @objc enum Category: Int32, CaseIterable {
        case clothes
        case food
        case entertainment
        case wellness
        case healthcare
        case education
        case tourism
        case present
        case salary
        case other
    }
    
//    var cellViewModel: TransactionCellViewModel {
//        TransactionCellViewModel(transferedMoney: Currency.currencyFormat(for: change, code: ), purpose: title, date: date.toShortFormat, icon: self.category.icon, isWithdrawal: isOutcome)
//    }
}

extension TransactionInfo.Category {
    var icon: UIImage{
        switch self {
        case .clothes:
            return .clothes
        case .food:
            return .food
        case .entertainment:
            return .entertainment
        case .wellness:
            return .wellness
        case .healthcare:
            return .healthcare
        case .education:
            return .study
        case .tourism:
            return .tourism
        case .present:
            return .present
        case .salary:
            return .salary
        case .other:
            return .other
        }
    }
    
    var title: String {
        switch self {
        case .clothes:
            return "Garments"
        case .food:
            return "Dining out"
        case .entertainment:
            return "Entertainment"
        case .wellness:
            return "Sport & wellness"
        case .healthcare:
            return "Healthcare"
        case .education:
            return "Education"
        case .tourism:
            return "Tourism"
        case .present:
            return "Presents"
        case .salary:
            return "Salary"
        case .other:
            return "Other"
        }
    }
}
