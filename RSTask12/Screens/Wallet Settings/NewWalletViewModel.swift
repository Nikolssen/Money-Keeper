//
//  NewWalletViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/28/21.
//

import Foundation
import UIKit

class NewWalletViewModel: SettingsViewModelling {

    
    var glassBarLeadingAction: (() -> Void)? {
        saveAndGoBack
    }
    
    var coordinator: WalletSettingsCoordinator
    var service: Service
    weak var delegate: SettingsViewModelDelegate?
    
    var walletInfo: WalletInfo
    var currentTitle: String {
        get { walletInfo.title }
        set { walletInfo.title = newValue }
    }
    
    var glassBarTrailingImage: UIImage?
    
    var glassBarTrailingAction: (() -> Void)?
    
    private func saveAndGoBack() {
        if walletInfo.title.isEmpty {
            delegate?.showAlert(title: "Warning!", message: "The wallet title appears to be empty.", leftButtonTitle: "Change", rightButtonTitle: "Back", leftButtonAction: {}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            return
        }
        
        if !isTitleValid(title: walletInfo.title) {
            delegate?.showAlert(title: "Warning!", message: "The wallet title appears to have been already used. Try another.", leftButtonTitle: "Change", rightButtonTitle: "Back", leftButtonAction:{}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            return
        }
        
        delegate?.showAlert(title: "Confirming new wallet", message: "Would you like to add wallet to your wallet list?", leftButtonTitle: "Yes", rightButtonTitle: "No", leftButtonAction: {[weak self]
            in
            guard let self = self else {return}
            self.service.coreDataService.addNewWallet(walletInfo: self.walletInfo, withUpdate: true)
            self.coordinator.goBack()}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            
    }
    
    var glassBarTitle: String {
        "Add new wallet"
    }
    
    
    var currentThemeImage: UIImage {
        walletInfo.theme.image
    }
    
    var currencyDescription: String {
        walletInfo.currencyCode
    }
    var currencyCode: String {
        if let symbol = Currency.symbol(for: walletInfo.currencyCode), symbol != walletInfo.currencyCode {
            return symbol
        }
         return ""
    }
    
    private func isTitleValid(title: String) -> Bool {
        return !service.coreDataService.doesWalletTitleExist(walletInfo: walletInfo)
    }
    
    func showColors() {
        coordinator.showColorThemes { [weak self] in
            self?.walletInfo.theme = $0
            self?.coordinator.colorTheme = $0
            self?.delegate?.setBackgroundImage(image: $0.image)
        }
    }
    
    func showCurrencies() {
        coordinator.showCurrencies(code: walletInfo.currencyCode) {[weak self] in
            self?.walletInfo.currencyCode = $0
        }
    }
    
    init(coordinator: WalletSettingsCoordinator, service: Service) {
        self.coordinator = coordinator
        self.service = service
        walletInfo = .init(theme: coordinator.colorTheme, currencyCode: Currency.localCurrencyCode, title: "", id: nil)
    }
    
}
