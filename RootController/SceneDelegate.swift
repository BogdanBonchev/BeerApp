//
//  SceneDelegate.swift
//  BeerApp
//
//  Created by Богдан Бончев on 10.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
        let beerPresenter = BeerPresenter(apiManager: ApiManager(), networkManager: NetworkManager())
        let mainViewController = MainViewController(beerPresenter: beerPresenter)
        beerPresenter.delegate = mainViewController
        let mainNavigation = UINavigationController(rootViewController: mainViewController)
        
        window = UIWindow(windowScene: windowsScene)
        window?.rootViewController = mainNavigation
        window?.makeKeyAndVisible()
    }
}

