//
//  UIViewController+Toast.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/2/22.
//

import Foundation
import UIKit
import Toast
import RxSwift
import RxCocoa

extension UIViewController{
    var toastBinding: Binder<String> {
        return Binder(self) { [weak self] viewController, message in
            self?.view.hideToast()
            self?.view.makeToast(message)
        }
    }
}
