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

    static func defaultProvider() -> ServicesProvider {
        let network = NetworkService()
        return ServicesProvider(network: network)
    }

    init(network: NetworkServiceType) {
        self.network = network
    }
}
