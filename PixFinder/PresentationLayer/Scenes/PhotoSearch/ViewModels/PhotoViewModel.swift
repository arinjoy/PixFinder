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

typealias ImageURLTuple = (preview: URL, mediumSize: URL, largeSize: URL)
typealias PostedByUser = (name: String, avatarUrl: URL)

struct PhotoViewModel {

    let id: Int
    let tags: String
    let pageUrl: URL

    let imageUrls: ImageURLTuple
    let mainImage: AnyPublisher<UIImage?, Never>

    let views: String
    let downloads: String
    let likes: String
    let comments: String

    let postedByUser: PostedByUser
    let userAvatarImage: AnyPublisher<UIImage?, Never>
    
    var accessibility: AccessibilityConfiguration?

    init(id: Int,
         tags: String,
         pageUrl: URL,
         imageUrls: ImageURLTuple,
         mainImage: AnyPublisher<UIImage?, Never>,
         views: String,
         downloads: String,
         likes: String,
         comments: String,
         postedByUser: PostedByUser,
         userAvatarImage: AnyPublisher<UIImage?, Never>,
         accessibility: AccessibilityConfiguration? = nil
    ) {
        self.id = id
        self.tags = tags
        self.pageUrl = pageUrl

        self.imageUrls = imageUrls
        self.mainImage = mainImage

        self.views = views
        self.downloads = downloads
        self.likes = likes
        self.comments = comments

        self.postedByUser = postedByUser
        self.userAvatarImage = userAvatarImage
        
        self.accessibility = accessibility
    }
}


/// Used for `NSDiffableDataSource`
extension PhotoViewModel: Hashable {

    static func == (lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
