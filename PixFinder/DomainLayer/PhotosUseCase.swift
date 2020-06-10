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

protocol PhotosUseCaseType {

    /// Runs photos search with a query string
    func searchPhotos(with query: String) -> AnyPublisher<Result<[Photo], Error>, Never>
}

final class PhotosUseCase: PhotosUseCaseType {

    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }

    func searchPhotos(with query: String) -> AnyPublisher<Result<[Photo], Error>, Never> {
        return networkService
        .load(Resource<PhotosList>.photos(query: query))
        .map({ (result: Result<PhotosList, NetworkError>) -> Result<[Photo], Error> in
            switch result {
            case .success(let photosList): return .success(photosList.photos)
            case .failure(let error): return .failure(error)
            }
        })
        .subscribe(on: DispatchQueue.global(qos: .userInteractive))
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
