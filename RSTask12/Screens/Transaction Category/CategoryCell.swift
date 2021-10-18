//
//  CategoryCell.swift
//  RSTask12
//
//  Created by Admin on 02.10.2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                leadingConstraint.constant = 30
                topConstraint.constant = 7.5
                titleLabel.font = .montserratSemibold19
            }
            else {
                leadingConstraint.constant = 0
                topConstraint.constant = 0
                titleLabel.font = .montserratSemibold24
            }
          layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.rickBlack.cgColor
        imageView.layer.borderWidth = 2
    }

    override func prepareForReuse() {
        leadingConstraint.constant = 0
        topConstraint.constant = 0
        titleLabel.font = .montserratSemibold24
        imageView.image = nil
    }
    
    func configure(with category: TransactionInfo.Category) {
        titleLabel.text = category.title
        imageView.image = category.icon
    }
}

extension CategoryCell: InstantiatableCell {
    static var reuseIdentifier: String {
        "CategoryCellID"
    }
    
    static var nib: UINib {
        UINib(nibName: "CategoryCell", bundle: nil)
    }
    
    static var height: CGFloat {
        75.0
    }
    
}
