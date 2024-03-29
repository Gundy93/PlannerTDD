//
//  SceneDelegate.swift
//  PlannerTDD
//
//  Created by Gundy on 2/8/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(
            rootViewController: PlanListViewController(
                viewModel: PlannerViewModel.init(
                    planner: .init(
                        list: []
                    )
                )
            )
        )
    }
}
