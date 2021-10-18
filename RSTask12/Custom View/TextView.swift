//
//  TextView.swift
//  RSTask12
//
//  Created by Admin on 29.09.2021.
//

import UIKit

final class TextView: UITextView {

    @IBInspectable var cornerRadius: CGFloat = 20 { didSet { layer.cornerRadius = cornerRadius } }

    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = cornerRadius
        backgroundColor = .clear
        font = .montserratSemibold24
        textColor = .rickBlack
    }
}
