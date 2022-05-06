//
//  SceneDelegate.swift
//  RSTask12
//
//  Created by Admin on 22.09.2021.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseAuth
import WidgetKit

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
    func sceneWillResignActive(_ scene: UIScene) {
        updateWidgetData()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        coordinator?.service.coreDataService.saveContext()
    }

    private func updateWidgetData() {
        
        guard Firebase.Auth.auth().currentUser?.uid != nil else {
        
            UserDefaults.init(suiteName: "group.budovich.task")?.set(false, forKey: "UserForWidget")
            return
        }
            UserDefaults.init(suiteName: "group.budovich.task")?.set(true, forKey: "UserForWidget")
        if let service = coordinator?.service.coreDataService {
            service.changeForToday()
        }
    }
}
