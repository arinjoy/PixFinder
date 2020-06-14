//
//  PixFinder+StringKeys.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 13/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

extension StringKeys {
    
    enum PixFinder: String, LocalizationKeys {
        
        case photoSearchNavigationTitle = "photoSearch.nav.title"
        case searchPlaceholderTitle = "photoSearch.placeholder.title"
        case searchNoResultsTitle = "photoSearch.noResults.title"
        case searchNoResultsMessage = "photoSearch.noResults.message"
        
        case genericErrorTitle = "error.generic.title"
        case genericErrorMessage = "error.generic.message"
        case netowrkErrorTitle = "error.network.title"
        case nerworkErrorMessage = "error.network.message"
        
        case userNamePrefix = "userName.prefix"
        case tagsPrefix = "tags.prefix"
        case likesCountSuffix = "likes.count.suffix"
        case commentsCountSuffix = "comments.count.suffix"
        case favouritesCountSuffix = "favourites.count.suffix"
        case downloadsCountSuffix = "downloads.count.suffix"
        case photoCellHint = "photo.cell.hint"

        // MARK: - LocalizationKeys
        
        var table: String? { return "PixFinder" }
    }
}
