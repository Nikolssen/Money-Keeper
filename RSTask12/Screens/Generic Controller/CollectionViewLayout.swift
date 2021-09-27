//
//  CollectionViewLayout.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import UIKit

class CollectionViewLayout: UICollectionViewFlowLayout {
    
    private enum Constants {
        static let inset: CGFloat = 25.0
        static let width: CGFloat = UIScreen.main.bounds.width - 2 * inset
    }
    init(height: CGFloat) {
        super.init()
        self.itemSize = CGSize(width: CollectionViewLayout.Constants.width, height: height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var _itemSize: CGSize = .zero
    
    override var itemSize: CGSize {
        get {
            _itemSize
        }
        set {
            _itemSize = newValue
        }
    }
    
    private var _sectionInset: UIEdgeInsets = UIEdgeInsets(top: .zero, left: CollectionViewLayout.Constants.inset, bottom: 0, right: CollectionViewLayout.Constants.inset)
    
    override var sectionInset: UIEdgeInsets {
        get {
            _sectionInset
        }
        set {
            _sectionInset = newValue
        }
    }
}
