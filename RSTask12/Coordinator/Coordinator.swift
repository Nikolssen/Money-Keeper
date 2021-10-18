//
//  Coordinator.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//
import UIKit

final class Coordinator {
    let rootViewController: UINavigationController = UINavigationController()
    let window: UIWindow
    let coreDataService: CoreDataServiceType = CoreDataService(containerName: "RSTask12")
    var colorTheme: ColorTheme = ColorTheme.allCases.randomElement()!
    
    func start() {
        rootViewController.setNavigationBarHidden(true, animated: false)
        rootViewController.setViewControllers([walletListController], animated: false)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func goBack() {
        rootViewController.popViewController(animated: true)
    }
}

extension Coordinator {
    var walletListController: WalletListController {
        let controller = WalletListController(nibName: UINib.walletList, bundle: nil)
        let viewModel = WalletListViewModel(service: coreDataService, coordinator: self)
        viewModel.delegate = controller
        controller.viewModel = viewModel
        return controller
    }
    
    
}

extension Coordinator: WalletListCoordinator, WalletSettingsCoordinator,
                       CollectionCoordinator, WalletCoordinator, TransactionListCoordinator, TransactionSettingsCoordinator,
                       TransactionCoordinator
{
    
    func goToNewWallet() {
        let walletSettingsController = SettingsController(nibName: UINib.walletSettings, bundle: nil)
        let viewModel = NewWalletViewModel(coordinator: self, service: coreDataService)
        viewModel.delegate = walletSettingsController
        walletSettingsController.viewModel = viewModel
        rootViewController.pushViewController(walletSettingsController, animated: true)
    }
    
    func goToWallet(walletInfo: WalletInfo) {
        let walletController = WalletController(nibName: UINib.wallet, bundle: nil)
        let viewModel = WalletViewModel(walletInfo: walletInfo, coordinator: self, service: coreDataService)
        walletController.viewModel = viewModel
        viewModel.delegate = walletController
        rootViewController.pushViewController(walletController, animated: true)
    }
    
    
    func popToWalletList() {
        rootViewController.popToRootViewController(animated: true)
    }
    
    func showCurrencies(code: String, callback: @escaping (String) -> Void) {
        let controller = CollectionController<CurrencyViewModel, CurrencyCell>()
        let viewModel = CurrencyViewModel(coordinator: self, currencyCode: code, callback: callback)
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func showColorThemes(callback: @escaping (ColorTheme) -> Void) {
        let controller = CollectionController<ColorThemeViewModel, ColorCell>()
        let viewModel = ColorThemeViewModel(coordinator: self, callback: callback)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func goToCategories(category: TransactionInfo.Category, callback: @escaping (TransactionInfo.Category) -> Void) {
        let controller = CollectionController<TransactionCategoryViewModel, CategoryCell>()
        let viewModel = TransactionCategoryViewModel(coordinator: self, category: category, callback: callback)
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func goEdit(wallet: WalletInfo) {
        let controller = SettingsController(nibName: UINib.walletSettings, bundle: nil)
        let viewModel = WalletEditingViewModel(coordinator: self, service: coreDataService, wallet: wallet)
        viewModel.delegate = controller
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    func goToEdit(transactionInfo: TransactionInfo, wallet: WalletInfo) {
        let controller = TransactionSettingsController(nibName: UINib.transactionSettings, bundle: nil)
        let viewModel = TransactionEditingViewModel(coordinator: self, service: coreDataService, walletInfo: wallet, transactionInfo: transactionInfo)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func goToNewTransaction(for wallet: WalletInfo) {
        let controller = TransactionSettingsController(nibName: UINib.transactionSettings, bundle: nil)
        let viewModel = NewTransactionViewModel(coordinator: self, service: coreDataService, walletInfo: wallet)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func goToAllTransaction(for wallet: WalletInfo) {
        let controller = CollectionController< TransactionListViewModel, TransactionCell>()
        let viewModel = TransactionListViewModel(coordinator: self, service: coreDataService, walletInfo: wallet)
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func showTransaction(for transaction: TransactionInfo, wallet: WalletInfo) {
        let controller = TransactionController(nibName: UINib.transaction, bundle: nil)
        let viewModel = TransactionViewModel(coordinator: self, service: coreDataService, wallet: wallet, transaction: transaction)
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    
}
