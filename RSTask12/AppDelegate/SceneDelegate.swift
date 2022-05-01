//
//  SceneDelegate.swift
//  RSTask12
//
//  Created by Admin on 22.09.2021.
//

import UIKit
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        self.window = window
//        let coordinator = Coordinator(window: window)
//        self.coordinator = coordinator
        IQKeyboardManager.shared.enable = true
//        coordinator.start()
        window.makeKeyAndVisible()
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        coordinator?.service.coreDataService.saveContext()
    }


}

