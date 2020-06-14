//
//  SearchPlaceholderViewModel.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct SearchPlaceholderViewModel {

    let image: UIImage
    let title: String
    let description: String?

    // TODO: load these string copies form `.strings` file
    
    static var startSearch: SearchPlaceholderViewModel {
        let title = StringKeys.PixFinder.searchPlaceholderTitle.localized()
        let image = UIImage(named: "search-circle") ?? UIImage()
        return SearchPlaceholderViewModel(image: image, title: title, description: nil)
    }

    static var noResults: SearchPlaceholderViewModel {
        let title = StringKeys.PixFinder.searchNoResultsTitle.localized()
        let description = StringKeys.PixFinder.searchNoResultsMessage.localized()
        let image = UIImage(named: "search-circle") ?? UIImage()
        return SearchPlaceholderViewModel(image: image, title: title, description: description)
    }

    static var genericError: SearchPlaceholderViewModel {
        let title = StringKeys.PixFinder.genericErrorTitle.localized()
        let description = StringKeys.PixFinder.genericErrorMessage.localized()
        let image = UIImage(named: "error-triangle") ?? UIImage()
        return SearchPlaceholderViewModel(image: image, title: title, description: description)
    }
    
    static var connectivityError: SearchPlaceholderViewModel {
        let title = StringKeys.PixFinder.netowrkErrorTitle.localized()
        let description = StringKeys.PixFinder.nerworkErrorMessage.localized()
        let image = UIImage(named: "wifi-disconnected") ?? UIImage()
        return SearchPlaceholderViewModel(image: image, title: title, description: description)
    }
}
