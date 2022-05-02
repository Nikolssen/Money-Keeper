//
//  RegistrationViewController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/1/22.
//

import UIKit
import RxCocoa
import RxSwift

final class RegistrationViewController: UIViewController {
    var viewModel: RegistrationViewModelType!
    @IBOutlet private var emailTextField: TextField!
    @IBOutlet private var passwordTextField: TextField!
    @IBOutlet private var repeatPasswordTextField: TextField!
    @IBOutlet private var emailWarningLabel: UILabel!
    @IBOutlet private var passwordWarningLabel: UILabel!
    @IBOutlet private var repeatPasswordWarningLabel: UILabel!
    @IBOutlet private var glassButton: GlassButton!
    @IBOutlet private var backgroundView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.font: UIFont.montserratSemibold19, .foregroundColor: UIColor.rickBlack.withAlphaComponent(0.4)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.font: UIFont.montserratSemibold19, .foregroundColor: UIColor.rickBlack.withAlphaComponent(0.4)])
        repeatPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Repeat Password", attributes: [.font: UIFont.montserratSemibold19, .foregroundColor: UIColor.rickBlack.withAlphaComponent(0.4)])
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailAddress)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        repeatPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.repeatPassword)
            .disposed(by: disposeBag)
        
        viewModel.emailCheckMessage
            .bind(to: emailWarningLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordCheckMessage
            .bind(to: passwordWarningLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.repeatPasswordCheckMessage
            .bind(to: repeatPasswordWarningLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isRegistrationEnabled
            .bind(to: glassButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        glassButton
            .rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)
        glassButton.layer.cornerRadius = 20
        glassButton.layer.masksToBounds = true
        
        let gr = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        gr.direction = .right
        view.addGestureRecognizer(gr)
    }

    @objc func goBack() {
        viewModel.goBack.accept(Void())
    }
}
