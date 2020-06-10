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
        
        self.appCoordinator = ApplicationFlowCoordinator(window: window,
                                                         dependencyProvider: ApplicationComponentsFactory())
        self.appCoordinator.start()

        self.window = window
        self.window?.makeKeyAndVisible()

        return true
    }
}

