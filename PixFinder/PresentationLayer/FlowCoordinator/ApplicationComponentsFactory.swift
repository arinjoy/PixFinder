//
//  ApplicationComponentsFactory.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import SwiftUI

/// The ApplicationComponentsFactory takes responsibity of creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
    // TODO: Add use case & service providers here

    private lazy var useCase: PhotosUseCaseType = {
        return PhotosUseCase(
            networkService: ServicesProvider.defaultProvider().network,
            imageLoaderService: ServicesProvider.defaultProvider().imageLoader
        )
    }()

    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {

    func rootViewController() -> UINavigationController {
        let rootViewController = UINavigationController()
        rootViewController.navigationBar.tintColor = UIColor.black
        return rootViewController
    }
}

extension ApplicationComponentsFactory: PhotoSearchFlowCoordinatorDependencyProvider {

    func photoSearchController(router: PhotoSearchRouting) -> UIViewController {

        // TODO: Maybe design via the nne ViewController (VC) and it own .xib file to load a VC and avoid
        // storyboard file in multiple VCs are being added and routing/navigating starts happening

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard
            let photoSearchVC = storyboard.instantiateViewController(withIdentifier: "PhotoSearch") as? PhotoSearchViewController
        else {
            fatalError("`PhotoSearchViewController` could not be constructed out of main storyboard")
        }

        let photoSearchVM = PhotoSearchViewModel(useCase: useCase,
                                                 router: router)
        
        // TODO: Improve this VM injection logic differently if possible
        photoSearchVC.viewModel = photoSearchVM
        return photoSearchVC
    }
    
    func photoDetailsController(_ photo: PhotoViewModel) -> UIViewController {
        let photoDetailsView = PhotoDetailsView(imageURL: photo.imageUrls.mediumSize.absoluteString,
                                           title: photo.postedByUser.name)
        let hostingVC = UIHostingController(rootView: photoDetailsView)
        return hostingVC
    }
}
