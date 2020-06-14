//
//  PhotoDetailsView.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 14/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import Combine

struct PhotoDetailsView: View {

    let viewModel: PhotoViewModel
    
    init(withViewModel viewModel: PhotoViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            PhotoDetailsContainerView(viewModel)
        }
        .navigationBarTitle(Text(viewModel.postedByUser.name), displayMode: .inline)
    }
}

struct PhotoDetailsContainerView: View {

    @ObservedObject var photoImagesViewModel: PhotoImagesViewModel
    
    init(_ viewModel: PhotoViewModel) {
        self.photoImagesViewModel = PhotoImagesViewModel(
            mainImageUrl: viewModel.imageUrls.mediumSize,avatarUrl:
            viewModel.postedByUser.avatarUrl)
    }

    var body: some View {
        Image(uiImage: photoImagesViewModel.mainImage ?? UIImage(named: "cute-cat")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

final class PhotoImagesViewModel: ObservableObject {
    
    @Published var mainImage: UIImage?
    @Published var avatarImage: UIImage?
    
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let imageLoaderService: ImageLoaderServiceType
    
    init(mainImageUrl: URL, avatarUrl: URL) {
        imageLoaderService = ServicesProvider.defaultProvider().imageLoader
    
        imageLoaderService.loadImage(from: mainImageUrl)
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.mainImage = image
            }.store(in: &cancellables)
        
        imageLoaderService.loadImage(from: avatarUrl)
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.avatarImage = image
            }.store(in: &cancellables)
    }
}

// MARK: - Xcode Previews

struct PhotoDetailsView_Preview: PreviewProvider {
        
    static var previews: some View {
        PhotoDetailsView(withViewModel: PhotoDetailsView_Preview.photoViewModel)
    }
    
    // MARK: - Sample Data / Helpers
    
    static let useCase: PhotosUseCaseType = PhotosUseCase(
        networkService: ServicesProvider.defaultProvider().network,
        imageLoaderService: ServicesProvider.defaultProvider().imageLoader
    )
    
    static let photoViewModel = PhotoViewModelTransformer.viewModel(
        from: Photo(
            id: 2083492,
            tags: "cat, kitten, cute, animal",
            pageUrl: "https://pixabay.com/fr/photos/cat-jeune-animal-curieux-fauve-2083492/",
            previewUrl: "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_150.jpg",
            mediumSizeUrl: "https://pixabay.com/get/54e0dd404e5bae14f1dc846096293177133edde7534c704c7c2d7ad69745cc51_640.jpg",
            largeSizeUrl: "https://pixabay.com/get/54e0dd404e5bae14f6da8c7dda7936781c39dfe651516c48702679d5954dcd51b1_1280.jpg",
            totalViews: 2828882,
            totalDownloads: 48723,
            favouritesCount: 834,
            likesCount: 83272,
            commentsCount: 236,
            postedByUserName: "lulu_cat_lover",
            postedByUserImageUrl: "https://cdn.pixabay.com/user/2015/12/16/17-56-55-832_250x250.jpg"
        ),
        mainImageLoader: { url in
            PhotoDetailsView_Preview.useCase.loadImage(for: url)
        },
        userAvatarImageLoader: { url in
            PhotoDetailsView_Preview.useCase.loadImage(for: url)
        }
    )!
}
