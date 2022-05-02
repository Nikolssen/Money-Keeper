//
//  SceneDelegate.swift
//  RSTask12
//
//  Created by Admin on 22.09.2021.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        let coordinator = Coordinator(window: window)
        self.coordinator = coordinator
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        coordinator.start()
        window.makeKeyAndVisible()
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        coordinator?.service.coreDataService.saveContext()
        UserDefaults.init(suiteName: "group.task12")?.set("PPP", forKey: "Main")
    }


}

