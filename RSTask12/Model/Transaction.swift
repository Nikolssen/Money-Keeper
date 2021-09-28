//
//  Transaction.swift
//  RSTask12
//
//  Created by Admin on 26.09.2021.
//

import Foundation
import UIKit

struct Transaction {
    enum Category {
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
    
    let date: Date
    var isOutcome: Bool
    var change: UInt
    var category: Transaction.Category
    var note: String
}


extension Transaction.Category {
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
}
