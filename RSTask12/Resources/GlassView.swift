//
//  GlassView.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/23/21.
//

import UIKit

final class GlassView: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.babyPowder.withAlphaComponent(0.55).cgColor, UIColor.babyPowder.withAlphaComponent(0.15).cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 1, y: 1)
        layer.endPoint = CGPoint(x: 0, y: 0)
        layer.cornerRadius = 20
        return layer
    }()
    
    private lazy var borderLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.babyPowder.withAlphaComponent(0.55).cgColor, UIColor.babyPowder.withAlphaComponent(0.15).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        return gradientLayer
    }()
    
    private lazy var shadowLayer: CALayer = {
        let layer = CALayer()
        layer.shadowColor = UIColor.white.withAlphaComponent(0.02).cgColor
        layer.shadowRadius = 50
        layer.shadowOffset = CGSize(width: 20, height: 20)
        layer.shadowOpacity = 1

        return layer
    }()
    
    private var borderShapeLayerMask: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    
    func commonInit() {
        layer.insertSublayer(shadowLayer, at: 0)
        layer.insertSublayer(gradientLayer, at: 1)
        layer.addSublayer(borderLayer)
        
        
        layer.cornerRadius = 20
        layer.borderColor = UIColor.babyPowder.withAlphaComponent(0.55).cgColor
        

        layer.masksToBounds = true
        backgroundColor = .clear
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = layer.bounds
        borderShapeLayerMask.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
        borderLayer.mask = borderShapeLayerMask
        borderLayer.frame = layer.bounds
        shadowLayer.frame = layer.bounds
        shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
    }
    

}
