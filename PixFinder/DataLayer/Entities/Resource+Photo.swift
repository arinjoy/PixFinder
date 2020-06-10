//
//  Resource+Photo.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

extension Resource {

    static func photos(query: String) -> Resource<PhotosList> {
        let url = ApiConstants.baseUrl
        let parameters: [String : CustomStringConvertible] = [
            "key": ApiConstants.apiKey,
            "q": query,
            "lang": Locale.preferredLanguages[0],
            "pretty": true,
            "per_page": 100 // TODO: make it configurable by passing in the method with query
            ]
        return Resource<PhotosList>(url: url, parameters: parameters)
    }
}

