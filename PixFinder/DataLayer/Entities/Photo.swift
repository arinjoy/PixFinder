//
//  Photo.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct Photo {
    let id: Int
    let tags: String
    let pageUrl: String

    let previewUrl: String
    let mediumSizeUrl: String
    let largeSizeUrl: String

    let views: Int64
    let downloads: Int64
    let favourites: Int64
    let likes: Int64
    let comments: Int64

    let postedByUserName: String
    let postedByUserImageUrl: String
}

extension Photo: Hashable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Photo: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id
        case tags
        case pageUrl = "pageURL"
        case previewUrl = "previewURL"
        case mediumSizeUrl = "webformatURL"
        case largeSizeUrl = "largeImageURL"
        case views
        case downloads
        case favourites = "favorites"
        case likes
        case comments
        case postedByUserName = "user"
        case postedByUserImageUrl = "userImageURL"
    }
}
