//
//  TransactionSettingsController.swift
//  RSTask12
//
//  Created by Admin on 02.10.2021.
//

import UIKit
import Alertift

class TransactionSettingsController: UIViewController {
    var viewModel: TransactionSettingsViewModelling!
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var glassBar: GlassBar!
    @IBOutlet var titleTextField: TextField!
    @IBOutlet var changeTextField: TextField!
    @IBOutlet var noteTextView: UITextView!
    @IBOutlet var glassSegmentControl: GlassSegmentControl!
    @IBOutlet var categoryPanel: GlassView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryImageView: UIImageView!
    
    private var allowedCharacters: CharacterSet = CharacterSet(charactersIn: ["0123456789", Locale.current.decimalSeparator].compactMap({$0}).joined())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glassBar.title = viewModel.barTitle
        titleTextField.text = viewModel.title
        changeTextField.text = viewModel.change
        glassSegmentControl.isOutcome = viewModel.isOutcome
        noteTextView.text = viewModel.note
        backgroundImageView.image = viewModel.backgroundImage
        

        
        glassBar.leadingHandler = viewModel.goBack
        categoryImageView.layer.cornerRadius = 5
        categoryImageView.layer.borderColor = UIColor.rickBlack.cgColor
        categoryImageView.layer.borderWidth = 2
        glassBar.leadingHandler = viewModel.goBack
        
        titleTextField.addTarget(self, action: #selector(titleValueChanged), for: .editingChanged)
        changeTextField.addTarget(self, action: #selector(changeValueChanged), for: .editingChanged)
        glassSegmentControl.addTarget(self, action: #selector(transactionTypeChanged), for: .valueChanged)
        
        categoryPanel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCategories)))
        changeTextField.delegate = self
        noteTextView.delegate = self
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryImageView.image = viewModel.category.icon
        categoryLabel.text = viewModel.category.title
    }
    
    @objc func transactionTypeChanged() {
        viewModel.isOutcome = glassSegmentControl.isOutcome
    }
    
    @objc func titleValueChanged() {
        viewModel.title = titleTextField.text ?? ""
    }

    @objc func changeValueChanged() {
        viewModel.change = changeTextField.text ?? "0"
    }
    
    @objc func showCategories() {
        viewModel.changeCategory()
    }
}

extension TransactionSettingsController: TransactionSettingsViewModelDelagate {
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

extension TransactionSettingsController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === changeTextField else { return true }
        for character in string.unicodeScalars {
            if !allowedCharacters.contains(character) {
                return false
            }
        }
        if let separator = Locale.current.decimalSeparator {
            if (textField.text?.contains(separator) ?? false) && string.contains(separator) {
                return false
            }
        }
        return true
    }
}

extension TransactionSettingsController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.note = noteTextView.text
    }
}

protocol TransactionSettingsViewModelling {
    var title: String { get set }
    var change: String { get set }
    var isOutcome: Bool { get set }
    var note: String? { get set }
    func goBack()
    var category: TransactionInfo.Category { get }
    var barTitle: String { get }
    var backgroundImage: UIImage { get }
    func changeCategory()
}

protocol TransactionSettingsCoordinator: CollectionCoordinator {
    func goToCategories(category: TransactionInfo.Category, callback: @escaping (TransactionInfo.Category) -> Void)
}

protocol TransactionSettingsViewModelDelagate: AnyObject {
    func showAlert(title: String, message: String, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: @escaping ()->Void, rightButtonAction: @escaping () -> Void)
}
