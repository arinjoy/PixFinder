//
//  AccessibilityIdentifers.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 13/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

public struct AccessibilityIdentifiers {
    
    public struct PhotoSearch {
        public static let rootViewId = "\(PhotoSearch.self).rootView"
        public static let collectionViewId = "\(PhotoSearch.self).collectionView"
        public static let searchTextFieldId = "\(PhotoSearch.self).searchTextField"
        public static let cellId = "\(PhotoSearch.self).cell"
    }
    
    
    public struct SearchPlaceholder {
        public static let rootViewId = "\(SearchPlaceholder.self).rootView"
        public static let imageViewId = "\(SearchPlaceholder.self).imageView"
        public static let titleLabelId = "\(SearchPlaceholder.self).titleLabel"
        public static let descriptionLabelId = "\(SearchPlaceholder.self).descriptionLabel"
    }
}
