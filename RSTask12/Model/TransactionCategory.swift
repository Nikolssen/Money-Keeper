//
//  TransactionCategory.swift
//  RSTask12
//
//  Created by Admin on 25.09.2021.
//

import Foundation
import UIKit

enum TransactionCategory {
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

extension TransactionCategory {
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
