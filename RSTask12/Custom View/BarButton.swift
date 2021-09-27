//
//  BarButton.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/24/21.
//

import UIKit

class BarButton: UIButton {

    @objc enum BarButtonStyle: Int {
        case normal, destructive
    }
    
    var style: BarButtonStyle = .normal
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                imageView?.tintColor = .deepSaffron
                tintColor = .deepSaffron
            }
            else {
                imageView?.tintColor = style == .normal ? .greenBlueCrayola : .amaranthRed
                tintColor = style == .normal ? .greenBlueCrayola : .amaranthRed
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView?.tintColor = style == .normal ? .greenBlueCrayola : .amaranthRed
        tintColor = style == .normal ? .greenBlueCrayola : .amaranthRed
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        imageView?.tintColor = style == .normal ? .greenBlueCrayola : .amaranthRed
        tintColor = style == .normal ? .greenBlueCrayola : .amaranthRed
    }

}
