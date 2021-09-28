//
//  ViewController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/23/21.
//

import UIKit

class WalletListController: UIViewController {
    
    @IBOutlet var glassBar: GlassBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    
    var viewModel: WalletListViewModelling!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(WalletCell.nib, forCellWithReuseIdentifier: WalletCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = viewModel
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: view.frame.width - 40, height: WalletCell.height)
        layout?.minimumLineSpacing = 20
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
    }
    
}

extension WalletListController: WalletListViewModelDelegate {
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func setInfoHidden(isHidden: Bool) {
        infoLabel.isHidden = isHidden
    }
    
    func setBackgroundImage(image: UIImage) {
        UIView.animate(withDuration: 0.8, delay: 0, options: .transitionCrossDissolve, animations: {self.backgroundImageView.image = image}, completion: nil)
    }
}

extension WalletListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.walletSelected(at: indexPath.item)
    }
}
