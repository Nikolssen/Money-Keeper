//
//  WalletListViewModel.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import Foundation
import UIKit

protocol WalletListViewModelling {
    func newWallet()
    func walletSelected(at index: Int)
}

protocol WalletListCoordinator {
    var colorTheme: ColorTheme { get }
    func goToNewWallet()
    func goToWallet()
}

protocol WalletListViewModelDelegate {
    func setBackgroundImage(image: UIImage)
}

class WalletListViewModel: WalletListViewModelling {
    
    private let coordinator: WalletListCoordinator
    private let service: CoreDataServiceType
    
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
}
