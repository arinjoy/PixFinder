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

    let totalViews: Int
    let totalDownloads: Int
    let likesCount: Int
    let commentsCount: Int

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
        case totalViews = "views"
        case totalDownloads = "downloads"
        case likesCount = "likes"
        case commentsCount = "comments"
        case postedByUserName = "user"
        case postedByUserImageUrl = "userImageURL"
    }
}
