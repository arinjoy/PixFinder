//
//  Photos.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct PhotosList {
    let photos: [Photo]
}

extension PhotosList: Decodable {

    private enum CodingKeys: String, CodingKey {
        case photos = "hits"
    }
}

