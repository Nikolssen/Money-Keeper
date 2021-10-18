//
//  SettingsController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/23/21.
//

import UIKit

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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        currencyLabel.text = viewModel.currencyDescription
        codeLabel.text = viewModel.currencyCode
        colorThemeImageView.image = viewModel.currentThemeImage
        backgroundImageView.image = viewModel.currentThemeImage
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    @objc private func showColorThemes() {
        viewModel.showColors()
    }
    
    @objc private func showCurrencies() {
        viewModel.showCurrencies()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewContentBottomConstraint.constant = keyboardSize.height + 50
            view.layoutIfNeeded()
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollViewContentBottomConstraint.constant = 60
        view.layoutIfNeeded()
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
        let glassAlert = GlassAlertController(nibName: "GlassAlertController", bundle: nil)
        glassAlert.loadViewIfNeeded()
        glassAlert.titleLabel.text = title
        glassAlert.messageLabel.text = message
        glassAlert.leftButton.setTitle(leftButtonTitle, for: .normal)
        glassAlert.rightButton.setTitle(rightButtonTitle, for: .normal)
        glassAlert.leftButtonAction = leftButtonAction
        glassAlert.rightButtonAction = rightButtonAction
        glassAlert.show(on: self)
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
