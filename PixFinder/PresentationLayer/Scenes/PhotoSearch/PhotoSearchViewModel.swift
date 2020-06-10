//
//  PhotoSearchViewModel.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import Combine

final class PhotoSearchViewModel: PhotoSearchViewModelType {

    // MARK: - Private Properties
    
    private let useCase: PhotosUseCaseType
    private var cancellables: [AnyCancellable] = []

    init(useCase: PhotosUseCaseType) {
        self.useCase = useCase
    }

    // MARK: - PhotoSearchViewModelType

    func transform(input: PhotoSearchViewModelInput) -> PhotoSearchViewModelOutput {

        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input.selection
            .sink(receiveValue: { photoId in
                // Note: Handle navigation of the detail screen of the photo (when this feature is developed in future)
                // Potenially via `Router` or `Navigator` protocol abstraction for unit testing of routing logic
            })
            .store(in: &cancellables)

        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.main)


        let photos = searchInput
            .flatMapLatest { [unowned self] query in
                self.useCase.searchPhotos(with: query)
            }
            .map({ result -> PhotoSearchState in
                switch result {
                case .success([]):
                    return .noResults
                case .success(let photos):
                    // TODO: pass mapped photos as `PhotoViewModel` array as success
                    return .success([])
                case .failure(let error):
                    return .failure(error)
                }
            })
            .eraseToAnyPublisher()

        let initialState: PhotoSearchViewModelOutput = .just(.idle)

        let emptySearchString: PhotoSearchViewModelOutput =
            searchInput
            .map { _ in .idle }
            .eraseToAnyPublisher()

        let idle: PhotoSearchViewModelOutput = Publishers.Merge(initialState, emptySearchString)
            .eraseToAnyPublisher()

        return Publishers.Merge(idle, photos)
            .eraseToAnyPublisher()
    }
}
