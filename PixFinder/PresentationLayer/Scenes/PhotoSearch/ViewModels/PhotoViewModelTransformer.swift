//
//  PhotoViewModelTransformer.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

struct PhotoViewModelTransformer {

    static func viewModel(from photo: Photo) -> PhotoViewModel? {

        // Note: Here comes the raw data model to presentation data model conversion logic via `Transformers`
        
        guard
            let pageUrl = URL(string: photo.pageUrl),
            let previewUrl = URL(string: photo.previewUrl),
            let mediumSizeUrl = URL(string: photo.mediumSizeUrl),
            let largeSizeUrl = URL(string: photo.largeSizeUrl),
            let postedByUserAvatarUrl = URL(string: photo.postedByUserImageUrl)
        else {
            return nil
        }
        return PhotoViewModel(id: photo.id,
                              tags: photo.tags,
                              pageUrl: pageUrl,
                              imageUrls: ImageURLTuple(preview: previewUrl,
                                                       mediumSize: mediumSizeUrl,
                                                       largeSize: largeSizeUrl),
                              views: photo.totalViews.roundedStringified,
                              downloads: photo.totalDownloads.roundedStringified,
                              favourites: photo.favouritesCount.roundedStringified,
                              likes: photo.likesCount.roundedStringified,
                              comments: photo.commentsCount.roundedStringified,
                              postedByUser: PostedByUser(name: photo.postedByUserName,
                                                         avatarUrl: postedByUserAvatarUrl))
    }
    
}

fileprivate extension Int {

    var roundedStringified: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million * 10) / 10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand * 10) / 10)K"
        }
        else {
            return "\(self)"
        }
    }
}
