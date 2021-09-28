//
//  SettingsController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/23/21.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet private var glassBar: GlassBar!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet private var colorThemePanel: GlassView!
    @IBOutlet private var currencyPanel: GlassView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet private var textField: TextField!
    @IBOutlet var scrollViewContentBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
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
}
