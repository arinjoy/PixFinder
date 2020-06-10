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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // TODO: Maybe design via the nne ViewController (VC) and it own .xib file to load a VC and avoid
        // storyboard file in multiple VCs are being added and routing/navigating starts happening
        return storyboard.instantiateViewController(withIdentifier: "PhotoSearch")
    }
}
