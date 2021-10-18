//
//  CurrencyCell.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/24/21.
//

import UIKit

class CurrencyCell: UICollectionViewCell {

    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var labelTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var currencyNameLabel: UILabel!
    override var isSelected: Bool {
        willSet {
            if newValue {
                leadingConstraint.constant = 30
                topConstraint.constant = 7.5
                labelLeadingConstraint.constant = 24
                labelTrailingConstraint.constant = 24
                currencyCodeLabel.font = .montserratSemibold19
                currencyNameLabel.font = .montserratSemibold19
            } else {
                leadingConstraint.constant = 0
                topConstraint.constant = 0
                labelLeadingConstraint.constant = 30
                labelTrailingConstraint.constant = 30
                currencyCodeLabel.font = .montserratSemibold24
                currencyNameLabel.font = .montserratSemibold24
            }
            layoutIfNeeded()
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
        currencyCodeLabel.font = .montserratSemibold24
        currencyNameLabel.font = .montserratSemibold24
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
