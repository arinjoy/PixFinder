//
//  ApplicationComponentsFactory.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

/// The ApplicationComponentsFactory takes responsibity of creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
    // TODO: Add use case & service providers here
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {

    func rootViewController() -> UINavigationController {
        let rootViewController = UINavigationController()
        rootViewController.navigationBar.tintColor = UIColor.black
        return rootViewController
    }
}

extension ApplicationComponentsFactory: PhotoSearchFlowCoordinatorDependencyProvider {
    func photoSearchController() -> UIViewController {
        return PhotoSearchViewController()
    }
}
