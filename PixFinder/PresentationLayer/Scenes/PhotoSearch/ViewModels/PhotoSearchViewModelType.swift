//
//  PhotoSearchViewModelType.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

struct PhotoSearchViewModelInput {

    /// Called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>

    /// Triggered when the search query is updated
    let search: AnyPublisher<String, Never>

    /// Called when the user selected an item from the list
    let selection: AnyPublisher<Int, Never>

    init(
        appear: AnyPublisher<Void, Never>,
        search: AnyPublisher<String, Never>,
        selection: AnyPublisher<Int, Never>
    ) {
        self.appear = appear
        self.search = search
        self.selection = selection
    }
}

typealias PhotoSearchViewModelOutput = AnyPublisher<PhotoSearchState, Never>


enum ImageType {
    case mainPhoto
    case userAvatar
}

protocol PhotoSearchViewModelType {

    func transform(input: PhotoSearchViewModelInput) -> PhotoSearchViewModelOutput

    /// A cache/store of images loaded for main photo images
    var mainImageStore: [IndexPath: UIImage?] { get set }

    /// A cache/store of images loaded for user avatar images
    var avatarImageStore: [IndexPath: UIImage?] { get set }

    /// Will add an image loading opeation at a specified indexPath (if not already added) for a type of image
    func addImageLoadOperation(atIndexPath indexPath: IndexPath, forImageType type: ImageType, updateCellClosure: ((UIImage?) -> Void)?)

    /// Will remove an image loading opeation at a specified indexPath (if exists) for a type of image
    func removeImageLoadOperation(atIndexPath indexPath: IndexPath, forImageType type: ImageType)

    /// Will reset/clear all image loading opeations for a type of image
    func resetAllImageLoaders(forImageType type: ImageType)
}

enum PhotoSearchState {
    case idle
    case loading
    case success([PhotoViewModel])
    case noResults
    case failure(Error)
}

extension PhotoSearchState: Equatable {

    static func == (lhs: PhotoSearchState, rhs: PhotoSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsPhotos), .success(let rhsPhotos)): return lhsPhotos == rhsPhotos
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}


