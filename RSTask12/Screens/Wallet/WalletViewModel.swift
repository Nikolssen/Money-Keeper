//
//  WalletViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 10/4/21.
//
import UIKit

protocol WalletViewModelling: UICollectionViewDataSource {
    func edit()
    func goBack()
    
    func showAllTransaction()
    func newTransaction()
    func update()
    func itemSelected(at index: Int)
    
    var balance: String { get }
    var walletTitle: String { get }
    var backgroundImage: UIImage { get }
    
    var numberOfCells: Int {get set}
    
}

protocol WalletCoordinator: AnyObject{
    var colorTheme: ColorTheme { get set }
    func goBack()
    func goEdit(wallet: WalletInfo)
    func goToNewTransaction(for wallet: WalletInfo)
    func goToAllTransaction(for wallet: WalletInfo)
    func showTransaction(for transaction: TransactionInfo, wallet: WalletInfo)
}

protocol WalletViewModelDelegate: AnyObject {
    func updateCollectionView()
    func setInfoHidden(isHidden: Bool)
}

final class WalletViewModel: NSObject, WalletViewModelling {
    let walletInfo: WalletInfo
    let coordinator: WalletCoordinator
    let service: Service
    weak var delegate: WalletViewModelDelegate?
    
    var transactions: [TransactionInfo] = [] { didSet {
            delegate?.setInfoHidden(isHidden: !transactions.isEmpty)
            delegate?.updateCollectionView()
    }    }
    
    
    var numberOfCells: Int = 3 {
        didSet {
            delegate?.updateCollectionView()
        }
    }
    
    func itemSelected(at index: Int) {
        coordinator.showTransaction(for: transactions[index], wallet: walletInfo)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfCells > transactions.count ? transactions.count : numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as? TransactionCell else { return UICollectionViewCell() }
        let transaction = transactions[indexPath.item]
        let change = transaction.change * (transaction.isOutcome ? -1 : +1)
        let transactionCellVM = TransactionCellViewModel(transferedMoney: Currency.currencyFormat(for: change, code: walletInfo.currencyCode), purpose: transaction.title, date: transaction.date.toShortFormat, icon: transaction.category.icon, isWithdrawal: transaction.isOutcome)
        
       cell.configure(with: transactionCellVM)
        return cell
    }
    
    
    
    var balance: String {
        Currency.currencyFormat(for: (service.coreDataService.totalBalance(for: walletInfo)), code: walletInfo.currencyCode)
    }
    
    var walletTitle: String {
        walletInfo.title
    }
    
    var backgroundImage: UIImage {
        coordinator.colorTheme.image
    }
    
    func edit() {
        coordinator.goEdit(wallet: walletInfo)
    }
    
    func showAllTransaction() {
        coordinator.goToAllTransaction(for: walletInfo)
    }
    
    func newTransaction() {
        coordinator.goToNewTransaction(for: walletInfo)
    }
    
    func update() {
        transactions = service.coreDataService.fetchTransactions(wallet: walletInfo)
    }
    
    func goBack() {
        coordinator.goBack()
    }
    
    init(walletInfo: WalletInfo, coordinator: WalletCoordinator, service: Service) {
        coordinator.colorTheme = walletInfo.theme
        self.walletInfo = walletInfo
        self.coordinator = coordinator
        self.service = service
    }
}
