//
//  Date.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/29/21.
//

import Foundation

extension Date {
    fileprivate static var shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter
    }()
    
    fileprivate static var extendedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter
    }()
    
    var toShortFormat: String {

        Date.shortDateFormatter.string(from: self).capitalized
    }
    
    var toExtendedFormat: String {

        Date.extendedDateFormatter.string(from: self).capitalized
    }
}
