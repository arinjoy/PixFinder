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

    static func viewModel(
        from photo: Photo,
        mainImageLoader: (URL) -> AnyPublisher<UIImage?, Never>,
        userAvatarImageLoader: (URL) -> AnyPublisher<UIImage?, Never>
    ) -> PhotoViewModel? {

        // Note: Here comes the raw data model to presentation data model conversion logic via `Transformer`
        // Data integrety rules can be checked here and `nil` can be returned which will end up being discarded
        // this photo item if one/more of its manadtory property is/are missing/incorrect
        
        guard
            let pageUrl = URL(string: photo.pageUrl),
            let previewUrl = URL(string: photo.previewUrl),
            let mediumSizeUrl = URL(string: photo.mediumSizeUrl),
            let largeSizeUrl = URL(string: photo.largeSizeUrl),
            let postedByUserAvatarUrl = URL(string: photo.postedByUserImageUrl)
        else {
            return nil
        }
        
        let accessibility = AccessibilityConfiguration(
            identifier: AccessibilityIdentifiers.PhotoSearch.cellId + ".\(photo.id)",
            label: UIAccessibility.createCombinedAccessibilityLabel(
                from: ["Photo by \(photo.postedByUserName)",
                       "With tags \(photo.tags)",
                       "\(photo.likesCount) likes",
                       "\(photo.commentsCount) comments",
                       "\(photo.favouritesCount) favourites",
                       "\(photo.totalDownloads) times downloaded",
                       ]),
            hint: "Double tap to see details",
            traits: .button)
        
        let shit = PhotoViewModel(id: photo.id,
                              tags: photo.tags,
                              pageUrl: pageUrl,
                              imageUrls: ImageURLTuple(preview: previewUrl,
                                                       mediumSize: mediumSizeUrl,
                                                       largeSize: largeSizeUrl),
                              mainImage: mainImageLoader(mediumSizeUrl),
                              views: photo.totalViews.roundedStringified,
                              downloads: photo.totalDownloads.roundedStringified,
                              favourites: photo.favouritesCount.roundedStringified,
                              likes: photo.likesCount.roundedStringified,
                              comments: photo.commentsCount.roundedStringified,
                              postedByUser: PostedByUser(name: photo.postedByUserName,
                                                         avatarUrl: postedByUserAvatarUrl),
                              userAvatarImage: userAvatarImageLoader(postedByUserAvatarUrl),
                              accessibility: accessibility)
        
        print(shit)
        return shit
    }
    
}

fileprivate extension Int {

    /// Returns a strigified representation of a large number such as 29.3K, 1.5M or just number if its less than a thousand
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
