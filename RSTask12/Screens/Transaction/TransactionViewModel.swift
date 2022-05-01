//
//  TransactionViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 10/5/21.
//

import Foundation
import UIKit

protocol TransactionViewModelling {
    var title: String { get }
    var change: String { get }
    var isOutcome: Bool { get }
    var note: String { get }
    var backgroundImage: UIImage { get }
    var barTitle: String { get }
    func goBack()
    func edit()
    func delete()
    func update()
}

final class TransactionViewModel: TransactionViewModelling {
    
    let coordinator: TransactionCoordinator
    let service: Service
    
    var transactionInfo: TransactionInfo
    let walletInfo: WalletInfo
    
    var barTitle: String {
        transactionInfo.date.toExtendedFormat
    }
    
    var title: String {
        transactionInfo.title
    }
    
    var change: String {
        if transactionInfo.isOutcome {
            return Currency.currencyFormat(for: -transactionInfo.change, code: walletInfo.currencyCode)
        }
        else {
            return Currency.currencyFormat(for: transactionInfo.change, code: walletInfo.currencyCode)
        }
        
    }
    
    var isOutcome: Bool {
        transactionInfo.isOutcome
    }
    
    var note: String {
        transactionInfo.note ?? ""
    }
    
    var backgroundImage: UIImage {
        coordinator.colorTheme.image
    }
    
    func goBack() {
        coordinator.goBack()
    }
    
    func edit() {
        coordinator.goToEdit(transactionInfo: transactionInfo, wallet: walletInfo)
    }
    
    func delete() {
        service.coreDataService.deleteTransaction(transaction: transactionInfo, from: walletInfo)
    }
    
    func update() {
        if let id = transactionInfo.id, let transaction = service.coreDataService.transaction(with: id) {
            transactionInfo = transaction
        }
    }
    
    
    init(coordinator: TransactionCoordinator, service: Service, wallet: WalletInfo, transaction: TransactionInfo) {
        self.coordinator = coordinator
        self.service = service
        self.transactionInfo = transaction
        self.walletInfo = wallet
    }
    
}

