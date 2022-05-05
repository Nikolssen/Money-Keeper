//
//  UIViewController+SpinnerView.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/5/22.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
    var activityIndicatorBinding: Binder<Bool>{
        return Binder(self, binding: { [weak self] (viewController, isRefreshing) in
            if isRefreshing
            {
                self?.showActivityIndicatorSpinner()
            }
            else
            {
                self?.hideActivityIndicatorSpinner()
            }
            
        })
    }
}

private extension UIViewController {
    var restID: String{
        return "ActivityIndicatorSpinner"
    }
    var spinnerBlurID: String{
        return "SpinnerBlur"
    }
    func showActivityIndicatorSpinner(){
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        effectView.alpha = 0.0
        effectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effectView)
        effectView.frame = view.bounds
        let spinner = SpinnerView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        effectView.contentView.addSubview(spinner)
        NSLayoutConstraint.activate([
            effectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            effectView.topAnchor.constraint(equalTo: view.topAnchor),
            effectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            effectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: effectView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: effectView.centerYAnchor)
        ])
        spinner.restorationIdentifier = restID
        effectView.restorationIdentifier = spinnerBlurID
        UIView.animate(withDuration: 0.3, animations: {
            effectView.alpha = 0.9
        }, completion: { _ in
            spinner.startAnimation(delay: 0.04, replicates: 18)
        })
    }
    
    func hideActivityIndicatorSpinner(){
        for item in view.subviews where item.restorationIdentifier == spinnerBlurID{
            for animationView in item.subviews where animationView.restorationIdentifier == restID{
                (animationView as! SpinnerView).stopAnimation()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                item.alpha = 0.0
            }, completion: { _ in
                item.removeFromSuperview()
            })
        }
    }
}
