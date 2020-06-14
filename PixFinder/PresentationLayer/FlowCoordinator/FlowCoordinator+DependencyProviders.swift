//
//  FlowCoordinator+DependencyProviders.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

/// The `ApplicationFlowCoordinatorDependencyProvider` protocol defines methods to
/// satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationFlowCoordinatorDependencyProvider: class {

    /// Creates UIViewController
    func rootViewController() -> UINavigationController
}

protocol PhotoSearchFlowCoordinatorDependencyProvider: class {
    
    /// Creates UIViewController to search for photos
    func photoSearchController(router: PhotoSearchRouting) -> UIViewController
    
    /// Creates UIViewController to show the details of a photo
    func photoDetailsController(_ viewModel: PhotoViewModel) -> UIViewController
}
