//
//  TransactionListViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 10/6/21.
//

import UIKit

protocol TransactionListCoordinator: CollectionCoordinator {
    func showTransaction(for transaction: TransactionInfo, wallet: WalletInfo)
}

protocol TransactionListDelegate: AnyObject {
    func updateCollectionView()
}

class TransactionListViewModel: NSObject, CollectionControllerViewModelling {
    weak var delegate: TransactionListDelegate?
    let coordinator: TransactionListCoordinator
    let service: Service
    var transactions: [TransactionInfo] = [] { didSet {
        delegate?.updateCollectionView()
    }
    }
    let walletInfo: WalletInfo
    
    func itemSelected(at index: Int) {
        coordinator.showTransaction(for: transactions[index], wallet: walletInfo)
    }
    
    func goBack() {
        coordinator.goBack()
    }
    
    var barTitle: String {
        "Transactions"
    }
    
    var backgroundImage: UIImage {
        coordinator.colorTheme.image
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        transactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as? TransactionCell else { return UICollectionViewCell() }
        let transaction = transactions[indexPath.item]
        let change = transaction.change * (transaction.isOutcome ? -1 : +1)
        let transactionCellVM = TransactionCellViewModel(transferedMoney: Currency.currencyFormat(for: change, code: walletInfo.currencyCode), purpose: transaction.title, date: transaction.date.toShortFormat, icon: transaction.category.icon, isWithdrawal: transaction.isOutcome)
        
       cell.configure(with: transactionCellVM)
        return cell
    }
    
    init(coordinator: TransactionListCoordinator, service: Service, walletInfo: WalletInfo) {
        self.coordinator = coordinator
        self.service = service
        self.walletInfo = walletInfo
        transactions = service.coreDataService.fetchTransactions(wallet: walletInfo)
    }
    
}
