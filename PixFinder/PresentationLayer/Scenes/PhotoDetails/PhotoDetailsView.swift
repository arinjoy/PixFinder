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
            PhotoDetailsContainerView(imageURL: viewModel.imageUrls.mediumSize)
        }
        .navigationBarTitle(Text(viewModel.postedByUser.name), displayMode: .inline)
    }
}

struct PhotoDetailsContainerView: View {
    
    @ObservedObject var remoteImageURL: RemoteImageURL

    init(imageURL: URL) {
        remoteImageURL = RemoteImageURL(imageURL)
    }

    var body: some View {
        Image(uiImage: remoteImageURL.data.isEmpty ?
                UIImage(named: "photo-frame")! : UIImage(data: remoteImageURL.data)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

class RemoteImageURL: ObservableObject {
    
    var didChange = PassthroughSubject<Data, Never>()
    
    @Published var data = Data() {
        didSet {
            update()
        }
    }
    
    func update() {
        didChange.send(data)
    }
    
    init(_ url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
            
        }.resume()
    }
}

// MARK: - PreviewProvider

struct PhotoDetailsView_Preview: PreviewProvider {
        
    static var previews: some View {
        PhotoDetailsView(withViewModel: PhotoDetailsView_Preview.photoViewModel)
    }
    
    // MARK: - Sample Data Helper
    
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
