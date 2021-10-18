//
//  TransactionEditingViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 10/5/21.
//

import UIKit

class TransactionEditingViewModel: TransactionSettingsViewModelling {
    
    private let coordinator: TransactionSettingsCoordinator
    private var transactionInfo: TransactionInfo
    private let walletInfo: WalletInfo
    private let service: CoreDataServiceType
    weak var delegate: TransactionSettingsViewModelDelagate?
    
    func goBack() {
        if transactionInfo.change == 0 {
            delegate?.showAlert(title: "Warning!", message: "Cannot update transaction with empty change.", leftButtonTitle: "Change", rightButtonTitle: "Back", leftButtonAction: {}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            return
        }
        
        if transactionInfo.title.isEmpty {
            delegate?.showAlert(title: "Warning!", message: "Cannot update transaction with empty title.", leftButtonTitle: "Change", rightButtonTitle: "Back", leftButtonAction: {}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            return
        }
        
        delegate?.showAlert(title: "Updating transaction.", message: "Would you like to update a transaction?", leftButtonTitle: "Yes", rightButtonTitle: "No", leftButtonAction: { [weak self] in guard let self = self else { return }
            self.service.changeTransaction(transactionInfo: self.transactionInfo)
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
    
    init(coordinator: TransactionSettingsCoordinator, service: CoreDataServiceType, walletInfo: WalletInfo, transactionInfo: TransactionInfo) {
        self.coordinator = coordinator
        self.service = service
        self.walletInfo = walletInfo
        self.transactionInfo = transactionInfo
}
}
