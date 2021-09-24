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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
