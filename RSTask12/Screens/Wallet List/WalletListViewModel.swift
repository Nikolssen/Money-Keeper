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
    func update()
    var backgroundImage: UIImage { get }
    func logout()
}

protocol WalletListCoordinator {
    var colorTheme: ColorTheme { get }
    func goToNewWallet()
    func goToWallet(walletInfo: WalletInfo)
    func goToAuth()
}

protocol WalletListViewModelDelegate: AnyObject {
    func updateCollectionView()
    func setInfoHidden(isHidden: Bool)
}

final class WalletListViewModel: NSObject, WalletListViewModelling {

    private let coordinator: WalletListCoordinator
    private let service: Service
    weak var delegate: WalletListViewModelDelegate?
    
    var wallets: [WalletInfo] = [] {
        didSet {
            delegate?.setInfoHidden(isHidden: !wallets.isEmpty)
            delegate?.updateCollectionView()
        }
    }
    
    private func cellViewModel(at index: Int) -> WalletCellViewModel {
        let wallet = wallets[index]
        let balance = service.coreDataService.totalBalance(for: wallet)
        let lastChangeDate = service.coreDataService.lastChangeDate(for: wallets[index])?.toExtendedFormat ?? "New"
        return WalletCellViewModel(title: wallets[index].title, balance: Currency.currencyFormat(for: balance, code: wallet.currencyCode), date: lastChangeDate)
    }
    
    init(service: Service, coordinator: WalletListCoordinator) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func newWallet() {
        coordinator.goToNewWallet()
    }
    var backgroundImage: UIImage {
        coordinator.colorTheme.image
    }
    
    
    
    func walletSelected(at index: Int) {
        coordinator.goToWallet(walletInfo: wallets[index])
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalletCell.reuseIdentifier, for: indexPath) as? WalletCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: cellViewModel(at: indexPath.item))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        wallets.count
    }
    
    func update() {
        wallets = service.coreDataService.fetchWallets()
        service.coreDataService.changeForToday()
    }
    func logout() {
        _ = service.firebaseService.logout()
        service.coreDataService.clearAll { [coordinator] in
            coordinator.goToAuth()
        }
        
    }
}
