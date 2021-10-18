//
//  GlassAlertController.swift
//  RSTask12
//
//  Created by Ivan Budovich on 9/29/21.
//

import UIKit

class GlassAlertController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var leftButton: GlassButton!
    @IBOutlet var rightButton: GlassButton!
    
    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightButton.glassStyle = .destructive
    }
    
    func show(on viewController: UIViewController) {
        let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        dimmingView.frame = viewController.view.bounds
        
        viewController.view.addSubview(dimmingView)
        dimmingView.restorationIdentifier = "DimmingView"
        
        viewController.addChild(self)
        view.frame = CGRect(x: (viewController.view.bounds.width / 2) - 150, y: viewController.view.bounds.height / 2 - 110, width: 300, height: 220)
        view.alpha = 0.0
        viewController.view.addSubview(view)
        UIView.animate(withDuration: 0.24, delay: 0.0, options: .transitionCrossDissolve, animations: { self.view.alpha = 1 }, completion: nil)
        self.didMove(toParent: viewController)
        
        
    }
    
    func hide() {
        let parentView = parent?.view
        willMove(toParent: nil)
        UIView.animate(withDuration: 0.24, delay: 0.0, options: .transitionCrossDissolve, animations: { self.view.alpha = 0.0 }, completion: {[weak self] _ in
            self?.view.removeFromSuperview()
            self?.removeFromParent()
            
        })
        if let parentView = parentView {
            for theView in parentView.subviews where theView.restorationIdentifier == "DimmingView" {
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .transitionCrossDissolve, animations: {theView.alpha = 0.0}, completion: {_ in theView.removeFromSuperview() })
                
            }
        }

    }

    @IBAction private func leftButtonAction(_ sender: Any) {
        leftButtonAction?()
        hide()
    }
    @IBAction private func rightButtonAction(_ sender: Any) {
        rightButtonAction?()
        hide()
    }
    
}
