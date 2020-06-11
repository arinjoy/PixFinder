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

    let title: String
    let description: String?
    let image: UIImage

    // TODO: load these string copies form `.strings` file
    
    static var startSearch: SearchPlaceholderViewModel {
        let title = NSLocalizedString("Search for a photo...", comment: "Search for a photo...")
        let image = UIImage(named: "search-icon") ?? UIImage()
        return SearchPlaceholderViewModel(title: title, description: nil, image: image)
    }

    static var noResults: SearchPlaceholderViewModel {
        let title = NSLocalizedString("No photos found!", comment: "No photos found!")
        let description = NSLocalizedString("Try searching again...", comment: "Try searching again...")
        let image = UIImage(named: "search-icon") ?? UIImage()
        return SearchPlaceholderViewModel(title: title, description: description, image: image)
    }

    static var dataLoadingError: SearchPlaceholderViewModel {
        let title = NSLocalizedString("Can't load search results!", comment: "Can't load search results!")
        let description = NSLocalizedString("Something went wrong. Try searching again...", comment: "Something went wrong. Try searching again...")
        let image = UIImage(named: "error-icon") ?? UIImage()
        return SearchPlaceholderViewModel(title: title, description: description, image: image)
    }
}
