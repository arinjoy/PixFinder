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

    /// The latest list of photos being shown as results of the latest search operation
    private var photoList: [PhotoViewModel] = [] {
        didSet {
            // While new photos are being assigned, cancel any existing image loading operations and image store
            self.resetAllImageLoaders(forImageType: .mainPhoto)
            self.resetAllImageLoaders(forImageType: .userAvatar)
        }
    }
    
    private var cancellables: [AnyCancellable] = []

    private var mainImageLoadingQueue = OperationQueue()
    private var mainImageLoadingOperations: [IndexPath: ImageLoadOperation] = [:]
    private var avatarImageLoadingQueue = OperationQueue()
    private var avatarImageLoadingOperations: [IndexPath: ImageLoadOperation] = [:]

    // MARK: - Dependency
    
    private let useCase: PhotosUseCaseType
    private weak var router: PhotoSearchRouting?

    init(useCase: PhotosUseCaseType,
         router: PhotoSearchRouting) {
        self.useCase = useCase
        self.router = router
    }

    // MARK: - PhotoSearchViewModelType

    var mainImageStore: [IndexPath : UIImage?] = [:]
    var avatarImageStore: [IndexPath : UIImage?] = [:]

    func transform(input: PhotoSearchViewModelInput) -> PhotoSearchViewModelOutput {

        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input.selection
            .sink(receiveValue: { [weak self] photoViewModel in
                // Navigate to detail page via router
                self?.router?.showDetails(forPhoto: photoViewModel)
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
                    self.photoList = []
                    return .noResults
                case .success(let photos):
                    self.photoList = self.photoViewModels(from: photos)
                    return .success(self.photoList)
                case .failure(let error):
                    self.photoList = []
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

    func addImageLoadOperation(atIndexPath indexPath: IndexPath, forImageType type: ImageType, updateCellClosure: ((UIImage?) -> Void)?) {

        switch type {
        case .mainPhoto:
            // If an image loader exists for this indexPath, do not add it again
            guard mainImageLoadingOperations[indexPath] == nil,
                photoList.count > indexPath.row
            else { return }

            let imageLoader = ImageLoadOperation(withUrl: photoList[indexPath.row].imageUrls.mediumSize)
            imageLoader.completionHandler = updateCellClosure
            mainImageLoadingQueue.addOperation(imageLoader)
            mainImageLoadingOperations[indexPath] = imageLoader

        case .userAvatar:
            // If an image loader exists for this indexPath, do not add it again
            guard avatarImageLoadingOperations[indexPath] == nil,
                photoList.count > indexPath.row
            else { return }

            let imageLoader = ImageLoadOperation(withUrl: photoList[indexPath.row].postedByUser.avatarUrl)
            imageLoader.completionHandler = updateCellClosure
            avatarImageLoadingQueue.addOperation(imageLoader)
            avatarImageLoadingOperations[indexPath] = imageLoader
        }
    }

    func removeImageLoadOperation(atIndexPath indexPath: IndexPath, forImageType type: ImageType) {

        switch type {
        case .mainPhoto:
            if let imageLoader = mainImageLoadingOperations[indexPath] {
                imageLoader.cancel()
                mainImageLoadingOperations.removeValue(forKey: indexPath)
            }
        case .userAvatar:
            if let imageLoader = avatarImageLoadingOperations[indexPath] {
                imageLoader.cancel()
                avatarImageLoadingOperations.removeValue(forKey: indexPath)
            }
        }
    }

    func resetAllImageLoaders(forImageType type: ImageType) {
        switch type {
        case .mainPhoto:
            for (indexPath, _) in mainImageLoadingOperations {
                removeImageLoadOperation(atIndexPath: indexPath, forImageType: .mainPhoto)
            }
            mainImageStore = [:]
        case .userAvatar:
            for (indexPath, _) in avatarImageLoadingOperations {
                removeImageLoadOperation(atIndexPath: indexPath, forImageType: .userAvatar)
            }
            avatarImageStore = [:]
        }
    }

    // MARK: - Private Helpers

    private func photoViewModels(from photos: [Photo]) -> [PhotoViewModel] {
        return photos.map { photo in
            return PhotoViewModelTransformer.viewModel(
                from: photo,
                mainImageLoader: { [unowned self] url in
                    self.useCase.loadImage(for: url)
                },
                userAvatarImageLoader: { [unowned self] url in
                    self.useCase.loadImage(for: url)
                })
        }
        .compactMap { $0 }
    }
}
