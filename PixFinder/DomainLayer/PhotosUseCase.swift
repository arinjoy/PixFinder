//
//  PhotosUseCase.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage

final class PhotosUseCase: PhotosUseCaseType {

    private let networkService: NetworkServiceType
    private let imageLoaderService: ImageLoaderServiceType

    init(networkService: NetworkServiceType, imageLoaderService: ImageLoaderServiceType) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }

    // MARK: - PhotosUseCaseType

    func searchPhotos(with query: String) -> AnyPublisher<Result<[Photo], NetworkError>, Never> {
        return networkService
        .load(Resource<PhotosList>.photos(query: query))
        .map({ (result: Result<PhotosList, NetworkError>) -> Result<[Photo], NetworkError> in
            switch result {
            case .success(let photosList): return .success(photosList.photos)
            case .failure(let error): return .failure(error)
            }
        })
        .subscribe(on: Scheduler.background)
        .receive(on: Scheduler.main)
        .eraseToAnyPublisher()
    }

    func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(url) }
        .flatMap { [weak self] url -> AnyPublisher<UIImage?, Never> in
            guard let self = self else { return .just(nil) }
            return self.imageLoaderService.loadImage(from: url)
        }
        .receive(on: Scheduler.main)
        .share()
        .eraseToAnyPublisher()
    }
}
