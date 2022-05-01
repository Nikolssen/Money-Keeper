//
//  WalletEditingViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/28/21.
//

import Foundation
import UIKit
import CoreData


class WalletEditingViewModel: SettingsViewModelling {
    var walletInfo: WalletInfo
    var coordinator: WalletSettingsCoordinator
    var service: Service
    weak var delegate: SettingsViewModelDelegate?
    
    var glassBarTrailingImage: UIImage? {
        .circleTrash
    }
    
    var glassBarTrailingAction: (() -> Void)? {
        delete
    }
    
    private func delete() {
        if let id = walletInfo.id {
            service.coreDataService.deleteWallet(with: id)
            coordinator.popToWalletList()
        }

    }
    
    var glassBarLeadingAction: (() -> Void)? {
        saveAndGoBack
    }
    
    private func saveAndGoBack() {
        if walletInfo.title.isEmpty {
            delegate?.showAlert(title: "Warning!", message: "The wallet title appears to be empty.", leftButtonTitle: "Change", rightButtonTitle: "Back", leftButtonAction: {}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            return
        }
        
        if !isTitleValid(title: walletInfo.title) {
            delegate?.showAlert(title: "Warning!", message: "The wallet title appears to have been allready used. Try another.", leftButtonTitle: "Change", rightButtonTitle: "Back", leftButtonAction:{}, rightButtonAction: {[weak self] in self?.coordinator.goBack()})
            return
        }
        
        delegate?.showAlert(title: "Confirm new wallet.", message: "Would you like to apply changes?", leftButtonTitle: "Yes", rightButtonTitle: "No", leftButtonAction:{[weak self]
            in
            guard let self = self else {return}
            self.service.coreDataService.changeWallet(walletInfo: self.walletInfo)
            self.coordinator.goBack()}, rightButtonAction:  {[weak self] in self?.coordinator.goBack()})
    }
    
    var glassBarTitle: String {
        "Edit wallet"
    }
    
    var currentTitle: String {
        get { walletInfo.title }
        set { walletInfo.title = newValue }
    }
    
    var currentThemeImage: UIImage {
        walletInfo.theme.image
    }
    
    var currencyDescription: String {
        Currency.name(for: walletInfo.currencyCode)
    }
    var currencyCode: String {
        Currency.symbol(for: walletInfo.currencyCode) ?? ""
    }
    
    func showColors() {
        coordinator.showColorThemes(callback: { [weak self] in
            self?.walletInfo.theme = $0
            self?.delegate?.setBackgroundImage(image: $0.image)
            self?.coordinator.colorTheme = $0
        })
    }
    
    func showCurrencies() {
        coordinator.showCurrencies(code: walletInfo.currencyCode) {[weak self] in
            self?.walletInfo.currencyCode = $0
        }
    }
    
    private func isTitleValid(title: String) -> Bool {
        return !service.coreDataService.doesWalletTitleExist(walletInfo: walletInfo)
    }
    
    init(coordinator: WalletSettingsCoordinator, service: Service, wallet: WalletInfo) {
        coordinator.colorTheme = wallet.theme
        self.coordinator = coordinator
        self.service = service
        self.walletInfo = wallet
    }
}
