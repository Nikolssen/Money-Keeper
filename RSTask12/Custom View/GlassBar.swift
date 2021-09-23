//
//  GlassBar.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/23/21.
//

import UIKit

class GlassBar: UIView {

    @IBOutlet var leadingButton: UIButton!
    @IBOutlet var trailingButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet private var contentView: UIView!
    
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
}
