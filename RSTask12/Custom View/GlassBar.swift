//
//  GlassBar.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/23/21.
//

import UIKit

final class GlassBar: UIView {

    @IBOutlet private var leadingButton: BarButton!
    @IBOutlet private var trailingButton: BarButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentView: UIView!

    @IBOutlet private var leadingLabelConstraint: NSLayoutConstraint!
    @IBOutlet private var buttonToLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet private var labelToButtonConstraint: NSLayoutConstraint!
    @IBOutlet private var trailingLabelConstraint: NSLayoutConstraint!
    @IBInspectable var leadingButtonStyle: BarButton.BarButtonStyle  {
        get { leadingButton.style }
        set { leadingButton.style = newValue }
        
    }
    @IBInspectable var trailingButtonStyle: BarButton.BarButtonStyle {
        get { trailingButton.style }
        set { trailingButton.style = newValue }
        
    }
    
    @IBInspectable var leadingImage: UIImage? {
        willSet {
            leadingButton.setImage(newValue, for: .normal)
            leadingButton.setImage(newValue?.withTintColor(.deepSaffron), for: .highlighted)
            leadingButton.isHidden = (newValue == nil)
            buttonToLabelConstraint.isActive = (newValue != nil)
            leadingLabelConstraint.isActive = (newValue == nil)
        }
    }
    
    @IBInspectable var trailingImage: UIImage? {
        willSet {
            trailingButton.setImage(newValue, for: .normal)
            trailingButton.setImage(newValue?.withTintColor(.deepSaffron), for: .highlighted)
            trailingButton.isHidden = (newValue == nil)
            trailingLabelConstraint.isActive = (newValue == nil)
            labelToButtonConstraint.isActive = (newValue != nil)
        }
    }
    
    @IBInspectable var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    var leadingHandler: ( () -> Void )?
    var trailingHandler: ( () -> Void )?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leadingLabelConstraint.constant = 30
        trailingLabelConstraint.constant = 30
        buttonToLabelConstraint.isActive = (leadingImage != nil)
        leadingLabelConstraint.isActive = (leadingImage == nil)
        trailingButton.isHidden = (trailingImage == nil)
        labelToButtonConstraint.isActive = (trailingImage != nil)
        trailingLabelConstraint.isActive = (trailingImage == nil)

        titleLabel.text = title
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GlassBar", owner: self, options: nil)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.frame = self.bounds
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @IBAction private func leadingAction(_ sender: Any) {
        leadingHandler?()
    }
    @IBAction private func trailingAction(_ sender: Any) {
        trailingHandler?()
    }
    
}
