//
//  TransactionCell.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/24/21.
//

import UIKit

class TransactionCell: UICollectionViewCell {

    
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
       
    func configure(with viewModel: TransactionCellViewModel) {
        amountLabel.textColor = viewModel.isWithdrawal ? .amaranthRed : .celadon
        nameLabel.text = viewModel.purpose
        imageView.image = viewModel.icon
        dateLabel.text = viewModel.date
    }
    
}

extension TransactionCell: InstantiatableCell {
    static var nib: UINib {
        UINib(nibName: "TransactionCell", bundle: nil)
    }
    
    static var height: CGFloat {
        90.0
    }
    
    static var reuseIdentifier: String {
        "TransactionCellID"
    }
    
    
}
