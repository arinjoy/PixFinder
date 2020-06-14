//
//  PhotoUseCaseType.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 12/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage

protocol PhotosUseCaseType {

    /// Searches for phtotos for a given query string
    func searchPhotos(with query: String) -> AnyPublisher<Result<[Photo], NetworkError>, Never>

    // Loads an image for the given url
    func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never>
}

