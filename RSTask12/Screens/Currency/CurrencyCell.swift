//
//  CurrencyCell.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/24/21.
//

import UIKit

class CurrencyCell: UICollectionViewCell {
    
    @IBOutlet var glassView: GlassView!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var labelTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var currencyNameLabel: UILabel!
    override var isSelected: Bool {
        willSet {
            UIView.animate(withDuration: 0.2) {
                if newValue {
                    self.glassView.radius = 16
                    self.leadingConstraint.constant = 30
                    self.topConstraint.constant = 7.5
                    self.labelLeadingConstraint.constant = 24
                    self.labelTrailingConstraint.constant = 24
                } else {
                    self.glassView.radius = 20
                    self.leadingConstraint.constant = 0
                    self.topConstraint.constant = 0
                    self.labelLeadingConstraint.constant = 30
                    self.labelTrailingConstraint.constant = 30
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: CurrencyCellViewModel) {
        currencyNameLabel.text = viewModel.currencyName
        currencyCodeLabel.text = viewModel.currencyCode
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConstraint.constant = 0
        topConstraint.constant = 0
        labelLeadingConstraint.constant = 30
        labelTrailingConstraint.constant = 30
        self.currencyCodeLabel.font = .montserratSemibold19
        self.currencyNameLabel.font = .montserratSemibold19
    }
}

extension CurrencyCell: InstantiatableCell {
    static var reuseIdentifier: String {
        "CurrencyCellID"
    }
    
    static var nib: UINib {
        UINib(nibName: "CurrencyCell", bundle: nil)
    }
    
    static var height: CGFloat {
        75.0
    }
    
    
}

struct CurrencyCellViewModel {
    var currencyCode: String
    var currencyName: String
}
