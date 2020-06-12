//
//  AppDelegate.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: ApplicationFlowCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let window =  UIWindow(frame: UIScreen.main.bounds)

        applyThemeStyles()
        
        appCoordinator = ApplicationFlowCoordinator(window: window,
                                                    dependencyProvider: ApplicationComponentsFactory())
        appCoordinator.start()

        self.window = window
        self.window?.makeKeyAndVisible()

        return true
    }

    private func applyThemeStyles() {
        window?.backgroundColor = Theme.backgroundColor
        window?.tintColor = Theme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.primaryTextColor]
    }
}

