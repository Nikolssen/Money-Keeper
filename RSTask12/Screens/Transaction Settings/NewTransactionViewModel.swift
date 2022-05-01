//
//  NewTransactionViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 10/5/21.
//

import UIKit

final class NewTransactionViewModel: TransactionSettingsViewModelling {

    
    private let coordinator: TransactionSettingsCoordinator
    private var transactionInfo: TransactionInfo
    private let walletInfo: WalletInfo
    private let service: Service
    weak var delegate: TransactionSettingsViewModelDelagate?
    
    func goBack() {
        if transactionInfo.change == 0 {
            delegate?.showAlert(title: "Warning!", message: "Cannot commit transaction with empty change.", leftButtonTitle: "Change", rightButtonTitle: "Back", leftButtonAction: {}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            return
        }
        
        if transactionInfo.title.isEmpty {
            delegate?.showAlert(title: "Warning!", message: "Cannot commit transaction with empty title.", leftButtonTitle: "Change", rightButtonTitle: "Back", leftButtonAction: {}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            return
        }
        
        delegate?.showAlert(title: "Commiting new transaction.", message: "Would you like to commit a transaction?", leftButtonTitle: "Yes", rightButtonTitle: "No", leftButtonAction: { [weak self] in guard let self = self else { return }
            self.service.coreDataService.addTransaction(transactionInfo: self.transactionInfo, in: self.walletInfo)
            self.coordinator.goBack()
        }, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
        
        
    }
    
    func changeCategory() {
        coordinator.goToCategories(category: transactionInfo.category) {
            [weak self] in
            self?.transactionInfo.category = $0
        }
    }
    
    var title: String {
        get {
            transactionInfo.title
        }
        set {
            transactionInfo.title = newValue
        }
    }
    
    var change: String {
        get {
            "\(transactionInfo.change)"
        }
        set {
            if let value = Decimal(string: newValue, locale: .current) {
                transactionInfo.change = value
            }
        }
    }
    
    var isOutcome: Bool {
        get {
            transactionInfo.isOutcome
        }
        set {
            transactionInfo.isOutcome = newValue
        }
    }
    
    var note: String? {
        get {
            transactionInfo.note
        }
        set {
            transactionInfo.note = newValue
        }
    }
    
    var category: TransactionInfo.Category {
        transactionInfo.category
    }
    
    var barTitle: String {
        "Add transaction"
    }
    
    var backgroundImage: UIImage {
        coordinator.colorTheme.image
    }
    
    init(coordinator: TransactionSettingsCoordinator, service: Service, walletInfo: WalletInfo) {
        self.coordinator = coordinator
        self.service = service
        self.walletInfo = walletInfo
        self.transactionInfo = TransactionInfo(title: "", date: Date(), isOutcome: true, change: 0, category: .other, note: nil, id: nil)
    }
    
}
