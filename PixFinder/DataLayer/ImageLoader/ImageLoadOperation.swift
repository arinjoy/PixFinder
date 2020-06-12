//
//  ImageLoadOperation.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 12/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

/// An async operation that is cancellable and is used to download an image from an URL
final class ImageLoadOperation: Operation {

    // MARK: - Public

    /// The image that is being downloaded. `nil` represents it's not loaded due to an error.
    var image: UIImage?

    /// A closure that is executed when this operation ends and the downloaded (or cached version) image data is passed back.
    /// `nil`value  represents that image has not been loaded due to some issue.
    var completionHandler: ((UIImage?) -> Void)?

    // MARK: - Private

    /// The image url to load from
    private let imageWebUrl: URL

    private var cancellable: AnyCancellable?


    private lazy var imageLoaderService: ImageLoaderServiceType = {
        let serviceProvider = ServicesProvider.defaultProvider()
        return serviceProvider.imageLoader
    }()


    // MARK: - Lifecycle

    init(withUrl url: URL) {
        imageWebUrl = url
    }

    override func main() {

        guard !isCancelled else { return }

        cancellable = imageLoaderService.loadImage(from: imageWebUrl)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: Scheduler.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.image = image
                self.completionHandler?(self.image)
            }
    }
}
