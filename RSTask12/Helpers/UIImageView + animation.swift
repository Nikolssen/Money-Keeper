//
//  UIImageView + animation.swift
//  RSTask12
//
//  Created by Admin on 29.09.2021.
//
import UIKit

extension UIImageView {
    func setAnimatedly(image: UIImage) {
        UIView.animate(withDuration: 0.8, delay: 0, options: .transitionCrossDissolve, animations: {self.image = image}, completion: nil)
    }
}
