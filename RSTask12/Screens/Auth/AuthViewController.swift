//
//  AuthViewController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/1/22.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet private var emailTextField: TextField!
    @IBOutlet private var passwordTextField: TextField!
    @IBOutlet private var repeatPasswordTextField: TextField!
    @IBOutlet var emailWarningLabel: UILabel!
    @IBOutlet var passwordWarningLabel: UILabel!
    @IBOutlet var repeatPasswordWarningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.font: UIFont.montserratSemibold19, .foregroundColor: UIColor.rickBlack.withAlphaComponent(0.4)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.font: UIFont.montserratSemibold19, .foregroundColor: UIColor.rickBlack.withAlphaComponent(0.4)])
        repeatPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Repeat Password", attributes: [.font: UIFont.montserratSemibold19, .foregroundColor: UIColor.rickBlack.withAlphaComponent(0.4)])
        repeatPasswordWarningLabel.isHidden = true
        emailWarningLabel.isHidden = true
        passwordWarningLabel.isHidden = true
    }


}
