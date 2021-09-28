//
//  TextField.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import UIKit

class TextField: UITextField {

    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 20, dy: 0)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 20, dy: 0)
    }
    @IBInspectable var cornerRadius: CGFloat = 20 { didSet { layer.cornerRadius = cornerRadius } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = cornerRadius
        backgroundColor = .clear
        borderStyle = .none
    }

}
