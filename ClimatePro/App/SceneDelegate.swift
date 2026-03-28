//
//  SceneDelegate.swift
//  ClimatePro
//
//  Created by Will on 2026-03-27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        // MARK: - Create View Controllers

        let homeVC = HomeViewController()
        let learnVC = VideoLearningViewController()
        let scanVC = GarbageScannerViewController()
        let friendsVC = FriendsLeaderboardViewController()
        let profileVC = ProfileViewController()

        // Embed Profile in Navigation Controller
        let profileNav = UINavigationController(rootViewController: profileVC)

        // MARK: - Tab Bar Controller

        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            homeVC,
            learnVC,
            scanVC,
            friendsVC,
            profileNav
        ]

        // MARK: - Tab Bar Icons

        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )

        learnVC.tabBarItem = UITabBarItem(
            title: "Learn",
            image: UIImage(systemName: "play.rectangle"),
            tag: 1
        )

        scanVC.tabBarItem = UITabBarItem(
            title: "Scan",
            image: UIImage(systemName: "camera.viewfinder"),
            tag: 2
        )

        friendsVC.tabBarItem = UITabBarItem(
            title: "Friends",
            image: UIImage(systemName: "person.2"),
            tag: 3
        )

        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            tag: 4
        )

        // MARK: - Final Setup

        window.rootViewController = tabBar
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
