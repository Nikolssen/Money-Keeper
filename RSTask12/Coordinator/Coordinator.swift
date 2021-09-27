//
//  Coordinator.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import Foundation
import UIKit

final class Coordinator {
    
    var colorTheme: ColorTheme = ColorTheme.allCases.randomElement()!
    func start() {
        
    }
    
}

extension Coordinator {
    var walletListController: WalletListController {
        let controller = WalletListController(nibName: UINib.walletList, bundle: nil)
        let viewModel = WalletListViewModel(service: CoreDataService(), coordinator: self)
        controller.viewModel = viewModel
        return controller
    }
    
    
}

extension Coordinator: WalletListCoordinator {
    func goToNewWallet() {
        
    }
    
    func goToWallet() {
        
    }
}
