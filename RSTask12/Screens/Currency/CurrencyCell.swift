//
//  CurrencyCell.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/24/21.
//

import UIKit

class CurrencyCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
