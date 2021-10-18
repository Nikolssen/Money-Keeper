//
//  WallerController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/28/21.
//

import UIKit

class WalletController: UIViewController {
    
    @IBOutlet var glassBar: GlassBar!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var backgroundImageView: UIImageView!
    var viewModel: WalletViewModelling!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(TransactionCell.nib, forCellWithReuseIdentifier: TransactionCell.reuseIdentifier)
        collectionView.dataSource = viewModel
        collectionView.delegate = self
        glassBar.leadingHandler = viewModel.goBack
        glassBar.trailingHandler = viewModel.edit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        balanceLabel.text = viewModel.balance
        viewModel.update()
        glassBar.title = viewModel.walletTitle
        
        backgroundImageView.image = viewModel.backgroundImage
        balanceLabel.text = viewModel.balance
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return }
        layout.itemSize = CGSize(width: view.frame.width - 80, height: TransactionCell.height)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.numberOfCells = Int(floor(collectionView.frame.size.height / TransactionCell.height))
    }

    @IBAction func transactionButtonTapped(_ sender: Any) {
        viewModel.showAllTransaction()
    }
    @IBAction func addTransactionButtonTapped(_ sender: Any) {
        viewModel.newTransaction()
    }
    
}

extension WalletController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.itemSelected(at: indexPath.item)
    }
}

extension WalletController: WalletViewModelDelegate {
    func updateCollectionView() {
        collectionView.reloadData()
    }
    func setInfoHidden(isHidden: Bool) {
        infoLabel.isHidden = isHidden
    }
}
