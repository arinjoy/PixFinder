//
//  ImageLoaderService.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 12/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

final class ImageLoaderService: ImageLoaderServiceType {

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in
                return UIImage(data: data)
            }
            .catch { error in
                return Just(nil)
            }
            .print("Image loading for: \(url)")
            .eraseToAnyPublisher()
    }
}
