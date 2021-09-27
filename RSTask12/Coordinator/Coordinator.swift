//
//  Coordinator.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//

import Foundation
import UIKit

final class Coordinator {
    let rootViewController: UINavigationController = UINavigationController()
    let window: UIWindow
    
    var colorTheme: ColorTheme = ColorTheme.allCases.randomElement()!
    func start() {
        rootViewController.setViewControllers([walletListController], animated: false)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    init(window: UIWindow) {
        self.window = window
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
