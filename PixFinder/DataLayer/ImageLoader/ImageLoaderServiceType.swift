//
//  ImageLoaderServiceType.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 12/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoaderServiceType: AnyObject {

    /// Loads an image from an web/network URL considering if the image for the same URL has been
    /// saved in-memory cache or not and finally returns the `UIImage` instance in from of reactive publisher signal
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
