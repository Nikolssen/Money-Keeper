//
//  Coordinator.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/27/21.
//
import UIKit
import Firebase
import FirebaseAuth

final class Coordinator {
    let rootViewController: UINavigationController = UINavigationController()
    let window: UIWindow
    let service: Service = Service()
    var colorTheme: ColorTheme = ColorTheme.allCases.randomElement()!
    
    func start() {
        rootViewController.setNavigationBarHidden(true, animated: false)
        if Auth.auth().currentUser?.uid != nil {
            rootViewController.setViewControllers([walletListController], animated: false)
        } else {
            rootViewController.setViewControllers([signInController], animated: false)
        }
        

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
        let viewModel = WalletListViewModel(service: service, coordinator: self)
        viewModel.delegate = controller
        controller.viewModel = viewModel
        return controller
    }
    
    var signInController: AuthorizationViewController {
        let controller = AuthorizationViewController(nibName: "AuthorizationViewController", bundle: nil)
        controller.viewModel = AuthorizationViewModel(coordinator: self, service: service)
        return controller
    }
    
    var signUpController: RegistrationViewController {
        let controller = RegistrationViewController(nibName: "RegistrationViewController", bundle: nil)
        controller.viewModel = RegistrationViewModel(coordinator: self, service: service)
        return controller
    }
    
    
}

extension Coordinator: WalletListCoordinator, WalletSettingsCoordinator,
                       CollectionCoordinator, WalletCoordinator, TransactionListCoordinator, TransactionSettingsCoordinator,
                       TransactionCoordinator
{
    
    func goToNewWallet() {
        let walletSettingsController = SettingsController(nibName: UINib.walletSettings, bundle: nil)
        let viewModel = NewWalletViewModel(coordinator: self, service: service)
        viewModel.delegate = walletSettingsController
        walletSettingsController.viewModel = viewModel
        rootViewController.pushViewController(walletSettingsController, animated: true)
    }
    
    func goToWallet(walletInfo: WalletInfo) {
        let walletController = WalletController(nibName: UINib.wallet, bundle: nil)
        let viewModel = WalletViewModel(walletInfo: walletInfo, coordinator: self, service: service)
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
        let viewModel = WalletEditingViewModel(coordinator: self, service: service, wallet: wallet)
        viewModel.delegate = controller
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    func goToEdit(transactionInfo: TransactionInfo, wallet: WalletInfo) {
        let controller = TransactionSettingsController(nibName: UINib.transactionSettings, bundle: nil)
        let viewModel = TransactionEditingViewModel(coordinator: self, service: service, walletInfo: wallet, transactionInfo: transactionInfo)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func goToNewTransaction(for wallet: WalletInfo) {
        let controller = TransactionSettingsController(nibName: UINib.transactionSettings, bundle: nil)
        let viewModel = NewTransactionViewModel(coordinator: self, service: service, walletInfo: wallet)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func goToAllTransaction(for wallet: WalletInfo) {
        let controller = CollectionController< TransactionListViewModel, TransactionCell>()
        let viewModel = TransactionListViewModel(coordinator: self, service: service, walletInfo: wallet)
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func showTransaction(for transaction: TransactionInfo, wallet: WalletInfo) {
        let controller = TransactionController(nibName: UINib.transaction, bundle: nil)
        let viewModel = TransactionViewModel(coordinator: self, service: service, wallet: wallet, transaction: transaction)
        controller.viewModel = viewModel
        rootViewController.pushViewController(controller, animated: true)
    }
    
    func goToAuth() {
        rootViewController.setViewControllers([signInController], animated: true)
    }
}

extension Coordinator: AuthorizationViewModelCoordinator, RegistrationViewModelCoordinator{
    func goToRegistration() {
        rootViewController.pushViewController(signUpController, animated: true)
    }
    
    func loggedIn() {
        rootViewController.setViewControllers([walletListController], animated: true)
    }
    
    func registered() {
        rootViewController.setViewControllers([walletListController], animated: true)
    }
    
    func backToAuthorization() {
        rootViewController.popViewController(animated: true)
    }
    
    func handle(error: Error){
        let nsError = error as NSError
        var message = String()
        switch nsError.code {
        //Firebase Auth Errors
        case AuthErrorCode.invalidRecipientEmail.rawValue, AuthErrorCode.invalidEmail.rawValue:
            message = "The user with this email address does not exist."
        case AuthErrorCode.userDisabled.rawValue:
            message = "The account with this email address was disabled."
        case AuthErrorCode.wrongPassword.rawValue, AuthErrorCode.userNotFound.rawValue:
            message = "The user does not exist or the password is wrong."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            message = "This is email is already in use."
        case AuthErrorCode.networkError.rawValue:
            message = "The network connection was lost during request."
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
            message = "Make sure you are using appropriate way of authorization."
        default:
            message = "An error happened. Please, make sure your data is valid and internet connection is stable."
        }
        rootViewController.topViewController?.toastBinding.onNext(message)
    }
}
