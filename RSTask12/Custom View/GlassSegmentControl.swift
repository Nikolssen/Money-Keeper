//
//  GlassSegmentControl.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import UIKit

final class GlassSegmentControl: UIControl {

    var value: Bool = true {
        willSet {
            if newValue {
                leadingButtonConstraint.priority = UILayoutPriority(rawValue: 950)
                trailingButtonConstraint.priority = UILayoutPriority(rawValue: 750)

            }
            else {
               leadingButtonConstraint.priority = UILayoutPriority(rawValue: 750)
               trailingButtonConstraint.priority = UILayoutPriority(rawValue: 950)
            }
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet private var contentView: GlassView!
    @IBOutlet private var incomeButton: UIButton!
    @IBOutlet private var outcomeButton: UIButton!
    
    @IBOutlet private var leadingButtonConstraint: NSLayoutConstraint!
    @IBOutlet private var trailingButtonConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        incomeButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 13)
        outcomeButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 13)
        value = true
    }
    
    @IBAction private func incomeButtonTapped(_ sender: Any) {
        value = true
        sendActions(for: .valueChanged)

    }
    @IBAction private func outcomeButtonTapped(_ sender: Any) {
        value = false
        sendActions(for: .valueChanged)
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
        Bundle.main.loadNibNamed("GlassSegmentControl", owner: self, options: nil)
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
    
}
