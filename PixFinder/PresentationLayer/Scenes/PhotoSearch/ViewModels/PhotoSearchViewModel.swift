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

        // TODO: for future feature fo detail page navigation
        input.selection
            .sink(receiveValue: { photoId in
                // Note: Handle navigation of the detail screen of the photo (when this feature is developed in future)
                // Potenially via `Router` or `Navigator` protocol abstraction for unit testing of routing logic
                print("Tapped photo:", photoId)
            })
            .store(in: &cancellables)

        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.main)
            .removeDuplicates()

        let photosResultState = searchInput
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] query in
                self.useCase.searchPhotos(with: query)
            }
            .map { result -> PhotoSearchState in
                switch result {
                case .success([]):
                    return .noResults
                case .success(let photos):
                    return .success(self.viewModels(from: photos))
                case .failure(let error):
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        let initialState: PhotoSearchViewModelOutput = .just(.idle)

        let emptySearchString: PhotoSearchViewModelOutput = searchInput
            .filter { $0.isEmpty }
            .map { _ in .idle }
            .eraseToAnyPublisher()

        let idleState: PhotoSearchViewModelOutput = Publishers.Merge(initialState, emptySearchString)
            .eraseToAnyPublisher()

        let loadingState: PhotoSearchViewModelOutput = searchInput
            .filter({ !$0.isEmpty })
            .throttle(for: .milliseconds(1000), scheduler: Scheduler.main, latest: true)
            .removeDuplicates()
            .map { _ in .loading }
            .eraseToAnyPublisher()

        let searchState = Publishers.Merge(loadingState, photosResultState)
            .removeDuplicates()
            .eraseToAnyPublisher()

        return Publishers.Merge(idleState, searchState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    private func viewModels(from photos: [Photo]) -> [PhotoViewModel] {
        return photos.map { photo in
            return PhotoViewModelTransformer.viewModel(
                from: photo,
                imageLoader: { [unowned self] url in
                    self.useCase.loadImage(for: url)
                })
        }
        .compactMap { $0 }
    }
}
