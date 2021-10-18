//
//  GlassButton.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/24/21.
//

import UIKit

final class GlassButton: UIButton {
    
    @objc enum GlassButtonStyle: Int {
        case destructive
        case normal
    }
    
    @IBInspectable var glassStyle: GlassButtonStyle = .normal {
        willSet {
            switch newValue {
            case .normal:
                setTitleColor(.greenBlueCrayola, for: .normal)
            case .destructive:
                setTitleColor(.amaranthRed, for: .normal)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let glassView = GlassView()
        glassView.isUserInteractionEnabled = false
        glassView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(glassView)
        NSLayoutConstraint.activate([
            glassView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassView.topAnchor.constraint(equalTo: topAnchor),
            glassView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        setTitleColor(.deepSaffron, for: .highlighted)
        switch glassStyle {
        case .normal:
            setTitleColor(.greenBlueCrayola, for: .normal)
        case .destructive:
            setTitleColor(.amaranthRed, for: .normal)
        }
        titleEdgeInsets = UIEdgeInsets(top: 6.5, left: 24, bottom: 6.5, right: 24)
        
    }

}
