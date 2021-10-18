//
//  TransactionController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 10/5/21.
//

import UIKit

class TransactionController: UIViewController {
    
    var viewModel: TransactionViewModelling!
    
    @IBOutlet var glassBar: GlassBar!
    @IBOutlet var editButton: BarButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var changeLabel: UILabel!
    @IBOutlet var noteTextView: UITextView!
    @IBOutlet var deleteButton: GlassButton!
    @IBOutlet var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glassBar.title = viewModel.barTitle
        glassBar.leadingHandler = viewModel.goBack
        deleteButton.glassStyle = .destructive
        backgroundImageView.image = viewModel.backgroundImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.update()
        noteTextView.text = viewModel.note
        changeLabel.text = viewModel.change
        changeLabel.textColor = viewModel.isOutcome ? .amaranthRed : .celadon
        titleLabel.text = viewModel.title
    }
    @IBAction func editButtonTapped(_ sender: Any) {
        viewModel.edit()
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        viewModel.delete()
    }
}

protocol TransactionCoordinator: CollectionCoordinator {
    func goToEdit(transactionInfo: TransactionInfo, wallet: WalletInfo)
}
