//
//  PhotoSearchFlowCoordinator.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

/// The `PhotoSearchFlowCoordinator` takes control over the flows on the photos search screen
class PhotoSearchFlowCoordinator: FlowCoordinator {
    fileprivate let rootController: UINavigationController
    fileprivate let dependencyProvider: PhotoSearchFlowCoordinatorDependencyProvider

    init(rootController: UINavigationController, dependencyProvider: PhotoSearchFlowCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchController = self.dependencyProvider.photoSearchController()
        self.rootController.setViewControllers([searchController], animated: false)
    }
}
