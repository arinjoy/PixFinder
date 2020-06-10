//
//  PhotoViewModel.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

typealias ImageUrls = (preview: URL, mediumSize: URL, largeSize: URL)
typealias PostedByUser = (name: String, avatarUrl: URL)

struct PhotoViewModel {

    let id: Int
    let tags: String
    let pageUrl: String

    let imageUrls: ImageUrls
    let mainImage: AnyPublisher<UIImage?, Never>

    let totalViews: Int64
    let totalDownloads: Int64
    let favouritesCount: Int64
    let likesCount: Int64
    let commentsCount: Int64

    let postedByUser: PostedByUser

    init(id: Int,
         tags: String,
         pageUrl: String,
         imageUrls: ImageUrls,
         mainImage: AnyPublisher<UIImage?, Never>,
         totalViews: Int64,
         totalDownloads: Int64,
         favouritesCount: Int64,
         likesCount: Int64,
         commentsCount: Int64,
         postedByUser: PostedByUser
    ) {
        self.id = id
        self.tags = tags
        self.pageUrl = pageUrl

        self.imageUrls = imageUrls
        self.mainImage = mainImage

        self.totalViews = totalViews
        self.totalDownloads = totalDownloads
        self.favouritesCount = favouritesCount
        self.likesCount = likesCount
        self.commentsCount = commentsCount

        self.postedByUser = postedByUser
    }
}

extension PhotoViewModel: Hashable {
    static func == (lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
