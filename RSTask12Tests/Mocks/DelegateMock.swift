//
//  DelegateMock.swift
//  RSTask12Tests
//
//  Created by Admin on 08.10.2021.
//

import Foundation
import UIKit

@testable import RSTask12

class WalletListDelegateMock: WalletListViewModelDelegate {
    var didUpdateCollectionView: Bool = false
    var isInfoLabelHidden: Bool = true
    
    func updateCollectionView() {
        didUpdateCollectionView = true
    }
    
    func setInfoHidden(isHidden: Bool) {
        isInfoLabelHidden = isHidden
    }
    
    
}

class WalletSettingsDelegateMock: SettingsViewModelDelegate {
    var didChangeBackgroundImage: Bool = false
    var shouldSelectLeadingAction: Bool = false
    
    func setBackgroundImage(image: UIImage) {
        didChangeBackgroundImage = true
    }
    
    func showAlert(title: String, message: String, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: @escaping () -> Void, rightButtonAction: @escaping () -> Void) {
        if shouldSelectLeadingAction {
            leftButtonAction()
        }
        else {
            rightButtonAction()
        }
    }
    
    
}
