//
//  SettingsController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/23/21.
//

import UIKit
import Alertift

final class SettingsController: UIViewController {

    @IBOutlet private var glassBar: GlassBar!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var colorThemePanel: GlassView!
    @IBOutlet private var currencyPanel: GlassView!
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var textField: TextField!
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var scrollViewContentBottomConstraint: NSLayoutConstraint!

    @IBOutlet private var codeLabel: UILabel!
    @IBOutlet private var colorThemeImageView: UIImageView!
    
    var viewModel: SettingsViewModelling!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorThemePanel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showColorThemes)))
        currencyPanel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCurrencies)))
        glassBar.trailingButtonStyle = .destructive
        glassBar.trailingHandler = viewModel.glassBarTrailingAction
        glassBar.trailingImage = viewModel.glassBarTrailingImage
        
        
        glassBar.leadingHandler = viewModel.glassBarLeadingAction
        glassBar.title = viewModel.glassBarTitle
        textField.text = viewModel.currentTitle
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(setTitle(sender:)), for: .editingChanged)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencyLabel.text = viewModel.currencyDescription
        codeLabel.text = viewModel.currencyCode
        colorThemeImageView.image = viewModel.currentThemeImage
        backgroundImageView.image = viewModel.currentThemeImage
        
    }
    
    
    @objc private func showColorThemes() {
        viewModel.showColors()
    }
    
    @objc private func showCurrencies() {
        viewModel.showCurrencies()
    }
    
}

extension SettingsController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    @objc func setTitle(sender: UITextField) {
        viewModel.currentTitle = sender.text ?? ""
    }
}

extension SettingsController: SettingsViewModelDelegate{
    func setBackgroundImage(image: UIImage) {
        backgroundImageView.setAnimatedly(image: image)
    }
    
    func showAlert(title: String, message: String, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: @escaping ()->Void, rightButtonAction: @escaping () -> Void) {
        Alertift.alert(title: title, message: message)
            .titleTextColor(.rickBlack)
            .messageTextColor(.deepSaffron)
            .buttonTextColor(.deepSaffron)
            .action(.default(leftButtonTitle))
            .action(.cancel(rightButtonTitle))
            .finally { action, _, _ in
                if action.style == .default {
                    leftButtonAction()
                }
                if action.style == .cancel {
                    rightButtonAction()
                }
            }
            .show()
    }
}


protocol SettingsViewModelling {
    var glassBarTrailingImage: UIImage? { get }
    var glassBarTrailingAction: (() -> Void)? { get }
    var glassBarLeadingAction: (() -> Void)? { get }
    var glassBarTitle: String { get }
    var currentTitle: String {get set}
    var currentThemeImage: UIImage { get }
    var currencyDescription: String { get }
    var currencyCode: String { get }
    var delegate: SettingsViewModelDelegate? {get set}
    func showColors()
    func showCurrencies()
}

protocol SettingsViewModelDelegate: AnyObject {
    func setBackgroundImage(image: UIImage)
    func showAlert(title: String, message: String, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: @escaping ()->Void, rightButtonAction: @escaping () -> Void)
}

protocol WalletSettingsCoordinator: AnyObject {
    func goBack()
    func popToWalletList()
    func showCurrencies(code: String, callback: @escaping (String) -> Void)
    func showColorThemes(callback: @escaping (ColorTheme) -> Void)
    var colorTheme: ColorTheme {get set}
}
