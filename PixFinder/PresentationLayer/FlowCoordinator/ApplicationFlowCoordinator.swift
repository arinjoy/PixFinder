//
//  ApplicationFlowCoordinator.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

 import UIKit

/// A `FlowCoordinator` takes responsibility about coordinating view controllers and driving the flow in the application.
protocol FlowCoordinator: AnyObject {

    /// Stars the flow
    func start()
}


/// The application flow coordinator. Takes responsibility about coordinating view controllers and driving the flow
class ApplicationFlowCoordinator: FlowCoordinator {

    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider & PhotoSearchFlowCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow
    func start() {

        let searchNavigationController = UINavigationController()
        searchNavigationController.navigationBar.tintColor = UIColor.black

        self.window.rootViewController = searchNavigationController

        let searchFlowCoordinator = PhotoSearchFlowCoordinator(rootController: searchNavigationController, dependencyProvider: self.dependencyProvider)
        searchFlowCoordinator.start()

        self.childCoordinators = [searchFlowCoordinator]
    }

}
