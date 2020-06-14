//
//  ServicesProvider.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

class ServicesProvider {

    /// The underlying network service to load HTTP network based data
    let network: NetworkServiceType

    /// The underlying image service to load images from HTTP or from saved cache
    let imageLoader: ImageLoaderServiceType

    static func defaultProvider() -> ServicesProvider {
        let sessionConfig = URLSessionConfiguration.ephemeral
        
        // Set 10 seconds timeout for the request,
        // otherwise defaults to 60 seconds which is too long.
        // This helps in network disconnection and error testing.
        sessionConfig.timeoutIntervalForRequest = 10
        sessionConfig.timeoutIntervalForResource = 10
        
        let network = NetworkService(with: sessionConfig)
        
        let imageLoader = ImageLoaderService()
        return ServicesProvider(network: network, imageLoader: imageLoader)
    }

    init(network: NetworkServiceType, imageLoader: ImageLoaderServiceType) {
        self.network = network
        self.imageLoader = imageLoader
    }
}
