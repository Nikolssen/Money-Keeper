//
//  AuthorizationViewController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/2/22.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthorizationViewController: UIViewController {

    @IBOutlet private var backgroundView: UIImageView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailWarningLabel: UILabel!
    @IBOutlet var passwordWarningLabel: UILabel!
    @IBOutlet var glassButton: GlassButton!
    @IBOutlet var registrationButton: UIButton!
    
    var viewModel: AuthorizationViewModelType!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.font: UIFont.montserratSemibold19, .foregroundColor: UIColor.rickBlack.withAlphaComponent(0.4)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.font: UIFont.montserratSemibold19, .foregroundColor: UIColor.rickBlack.withAlphaComponent(0.4)])
        
        registrationButton.rx
            .tap
            .bind(to: viewModel.registration)
            .disposed(by: disposeBag)
        
        viewModel.passwordCheckMessage
            .bind(to: passwordWarningLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emailCheckMessage
            .bind(to: emailWarningLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLoginEnabled
            .bind(to: glassButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailAddress)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        glassButton.layer.cornerRadius = 20
        glassButton.layer.masksToBounds = true
        
        viewModel.activityIndicator
            .bind(to: activityIndicatorBinding)
            .disposed(by: disposeBag)
        
        glassButton
            .rx.tap
            .bind(to: viewModel.login)
            .disposed(by: disposeBag)
        
    }


}
