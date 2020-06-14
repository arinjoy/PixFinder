//
//  PhotoSearchFlowCoordinator.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

/// The `PhotoSearchFlowCoordinator` takes control over the flows starting in the photos search screen
class PhotoSearchFlowCoordinator: FlowCoordinator {
    
    private let rootController: UINavigationController
    private let dependencyProvider: PhotoSearchFlowCoordinatorDependencyProvider

    init(rootController: UINavigationController, dependencyProvider: PhotoSearchFlowCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchController = self.dependencyProvider.photoSearchController(router: self)
        self.rootController.setViewControllers([searchController], animated: false)
    }
}

extension PhotoSearchFlowCoordinator: PhotoSearchRouting {

    func showDetails(forPhoto photo: PhotoViewModel) {
        let controller = self.dependencyProvider.photoDetailsController(photo)
        self.rootController.pushViewController(controller, animated: true)
    }
}
