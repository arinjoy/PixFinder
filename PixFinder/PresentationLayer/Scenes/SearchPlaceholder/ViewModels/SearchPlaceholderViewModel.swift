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
        let title = NSLocalizedString("Search for a photo.", comment: "Search for a photo.")
        let image = UIImage(named: "search-circle") ?? UIImage()
        return SearchPlaceholderViewModel(image: image, title: title, description: nil)
    }

    static var noResults: SearchPlaceholderViewModel {
        let title = NSLocalizedString("No photos found!", comment: "No photos found!")
        let description = NSLocalizedString("Try searching again.", comment: "Try searching again.")
        let image = UIImage(named: "search-circle") ?? UIImage()
        return SearchPlaceholderViewModel(image: image, title: title, description: description)
    }

    static var dataLoadingError: SearchPlaceholderViewModel {
        let title = NSLocalizedString("Can't load search results!", comment: "Can't load search results!")
        let description = NSLocalizedString("Something went wrong. Try again please.", comment: "Something went wrong. Try again please. ")
        let image = UIImage(named: "error-triangle") ?? UIImage()
        return SearchPlaceholderViewModel(image: image, title: title, description: description)
    }
}
