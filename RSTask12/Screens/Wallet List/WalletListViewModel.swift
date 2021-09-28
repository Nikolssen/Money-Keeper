//
//  WalletListViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import Foundation
import UIKit

protocol WalletListViewModelling: UICollectionViewDataSource {
    func newWallet()
    func walletSelected(at index: Int)
}

protocol WalletListCoordinator {
    var colorTheme: ColorTheme { get }
    func goToNewWallet()
    func goToWallet()
}

protocol WalletListViewModelDelegate: AnyObject {
    func setBackgroundImage(image: UIImage)
    func updateCollectionView()
    func setInfoHidden(isHidden: Bool)
}

class WalletListViewModel: NSObject, WalletListViewModelling {
    
    private let coordinator: WalletListCoordinator
    private let service: CoreDataServiceType
    weak var delegate: WalletListViewModelDelegate?
    
    var wallets: [Wallet] = [] {
        willSet {
            if wallets.isEmpty {
                delegate?.setInfoHidden(isHidden: false)
            }
            else {
                delegate?.setInfoHidden(isHidden: true)
                delegate?.updateCollectionView()
            }
        }
    }
    
    init(service: CoreDataServiceType, coordinator: WalletListCoordinator) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func newWallet() {
        coordinator.goToNewWallet()
    }
    
    func walletSelected(at index: Int) {
        coordinator.goToWallet()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalletCell.reuseIdentifier, for: indexPath) as? WalletCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: wallets[indexPath.item].viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        wallets.count
    }
}
