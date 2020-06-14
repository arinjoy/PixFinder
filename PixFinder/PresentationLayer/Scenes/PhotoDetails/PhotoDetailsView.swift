//
//  PhotoDetailsView.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 14/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

struct PhotoDetailsView: View {

    let viewModel: PhotoViewModel
    
    init(withViewModel viewModel: PhotoViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                PhotoDetailsContainerView(viewModel)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: .infinity,
                           alignment: .center)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle(Text(viewModel.postedByUser.name), displayMode: .inline)
    }
}

// MARK: - Xcode Previews

#if DEBUG
struct PhotoDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoDetailsView(withViewModel: PhotoDetailsView_Preview_Helpers.photoViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            PhotoDetailsView(withViewModel: PhotoDetailsView_Preview_Helpers.photoViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
                .environment(\.colorScheme, .dark)
        }
    }
}

struct PhotoDetailsView_Preview_Helpers {
    
    static let useCase: PhotosUseCaseType = PhotosUseCase(
        networkService: ServicesProvider.defaultProvider().network,
        imageLoaderService: ServicesProvider.defaultProvider().imageLoader
    )
    
    static let photoViewModel = PhotoViewModelTransformer.viewModel(
        from: Photo(
            id: 2083492,
            tags: "cat, kitten, cute, animal, adorable, cuddly",
            pageUrl: "https://pixabay.com/fr/photos/cat-jeune-animal-curieux-fauve-2083492/",
            previewUrl: "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_150.jpg",
            mediumSizeUrl: "https://pixabay.com/get/54e0dd404e5bae14f1dc846096293177133edde7534c704c7c2d7ad69745cc51_640.jpg",
            largeSizeUrl: "https://pixabay.com/get/54e0dd404e5bae14f6da8c7dda7936781c39dfe651516c48702679d5954dcd51b1_1280.jpg",
            totalViews: 282888,
            totalDownloads: 48723,
            favouritesCount: 8344,
            likesCount: 83272,
            commentsCount: 236,
            postedByUserName: "lulu_cat_lover",
            postedByUserImageUrl: "https://cdn.pixabay.com/user/2015/12/16/17-56-55-832_250x250.jpg"
        ),
        mainImageLoader: { url in
            PhotoDetailsView_Preview_Helpers.useCase.loadImage(for: url)
        },
        userAvatarImageLoader: { url in
            PhotoDetailsView_Preview_Helpers.useCase.loadImage(for: url)
        }
    )!
}
#endif
