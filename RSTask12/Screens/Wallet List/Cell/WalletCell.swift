//
//  WalletCell.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/23/21.
//

import UIKit

class WalletCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with viewModel: WalletCellViewModel) {
        titleLabel.text = viewModel.title
        accountLabel.text = viewModel.balance
        dateLabel.text = viewModel.date
    }

}
extension WalletCell: InstantiatableCell {
    static var nib: UINib {
        UINib(nibName: "WalletCell", bundle: nil)
    }
    
    static var height: CGFloat {
        208.0
    }
    
    static var reuseIdentifier: String {
        "WalletCellID"
    }
    
}
