//
//  ColorTheme.swift
//  RSTask12
//
//  Created by Admin on 25.09.2021.
//

import Foundation
import UIKit

enum ColorTheme {
    case yellow, red, violet, green, blue, vista, aurora, morningStar
}

extension ColorTheme {
    var image: UIImage {
        switch self {
        case .yellow:
            return .yellowBackground
        case .red:
            return .redBackground
        case .violet:
            return .violetBackground
        case .green:
            return .greenBackground
        case .blue:
            return .blueBackground
        case .vista:
            return .vistaBackground
        case .aurora:
            return .auroraBackground
        case .morningStar:
            return .morningStarBackground
        }
    }
}
