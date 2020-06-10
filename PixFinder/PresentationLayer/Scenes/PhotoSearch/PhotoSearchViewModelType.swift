//
//  PhotoSearchViewModelType.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine



protocol PhotoSearchViewModelType {
    func transform(input: PhotoSearchViewModelInput) -> PhotoSearchViewModelOutput
}

struct PhotoSearchViewModelInput {

    /// Called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>

    /// Triggered when the search query is updated
    let search: AnyPublisher<String, Never>

    /// Called when the user selected an item from the list
    let selection: AnyPublisher<Int, Never>
}

typealias PhotoSearchViewModelOutput = AnyPublisher<PhotoSearchState, Never>

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
        case (.success(let lhsPhotos), .success(let rhsPhotos)): return lhsPhotos == lhsPhotos
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}


