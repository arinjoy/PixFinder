//
//  ImageCache.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 13/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import ImageIO

/// A protocol to support an  in-memory image cache
protocol ImageCacheType: class {

    /// Returns the image associated with a given url
    func image(for url: URL) -> UIImage?

    /// Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)

    /// Removes the image of the specified url in the cache
    func removeImage(for url: URL)

    /// Removes all images from the cache
    func removeAllImages()

    /// Accesses the value associated with the given key for reading and writing
    subscript(_ url: URL) -> UIImage? { get set }
}

final class ImageCache: ImageCacheType {

    /// 1st level cache, that contains encoded images
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()

    /// 2nd level cache, that contains decoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()

    private let lock = NSLock()
    private let config: Config

    struct Config {

        /// The maximum number of images to be supported/saved in the cache before start deleting
        let countLimit: Int

        /// The maximum memory limit to hold the images data (in bytes)
        let memoryLimit: Int

        // Note: Change if needed and customise based on device type/model
        static let defaultConfig = Config(countLimit: 1000, // 1000 images supported
                                          memoryLimit: (1024 * 1024) * 1000)
    }

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }

    func image(for url: URL) -> UIImage? {

        lock.lock()
        defer { lock.unlock() }

        // The best case scenario -> there is a decoded image in 1st level cache
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }

        // Else search for image data in 2nd level cache
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
            return decodedImage
        }
        return nil
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else {
            return removeImage(for: url)
        }
        let decompressedImage = image.decodedImage()

        lock.lock()
        defer { lock.unlock() }

        imageCache.setObject(decompressedImage,
                             forKey: url as AnyObject,
                             cost: 1)
        decodedImageCache.setObject(image as AnyObject,
                                    forKey: url as AnyObject,
                                    cost: decompressedImage.diskSize)
    }

    func removeImage(for url: URL) {
        lock.lock()
        defer { lock.unlock() }

        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }

    func removeAllImages() {
        lock.lock()
        defer { lock.unlock() }

        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }

    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}

fileprivate extension UIImage {

    func decodedImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        self.draw(at: CGPoint.zero)
        UIGraphicsEndImageContext()
        return self
    }

    // Rough estimation of how much memory image uses in bytes
    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}



