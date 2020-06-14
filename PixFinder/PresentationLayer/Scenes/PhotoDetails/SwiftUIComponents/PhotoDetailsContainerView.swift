//
//  PhotoDetailsContainerView.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 15/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI

struct PhotoDetailsContainerView: View {
    
    @ObservedObject var photoImagesViewModel: PhotoImagesViewModel
    
    private let viewModel: PhotoViewModel
    
    init(_ viewModel: PhotoViewModel) {
        self.photoImagesViewModel = PhotoImagesViewModel(
            mainImageUrl: viewModel.imageUrls.mediumSize,avatarUrl:
            viewModel.postedByUser.avatarUrl)
        self.viewModel = viewModel
    }

    var body: some View {
    
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(uiImage: photoImagesViewModel.mainImage ?? UIImage(named: "photo-frame")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .overlay(
                        Rectangle().stroke(Color(Theme.tintColor), lineWidth: 0.5)
                    )
                    .shadow(color: Color(Theme.tintColor), radius: 20, x: 0, y: -5)
                Image(uiImage: photoImagesViewModel.avatarImage ?? UIImage(named: "user-avatar")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color(Theme.tintColor), lineWidth: 0.5)
                    )
                    .shadow(color: Color(Theme.tintColor), radius: 10, x: 0, y: 0)
                    .padding(.bottom, -50)
                    .padding(.trailing, 10)
            }.padding(.bottom, -5)

            DetailsTextualInfoView(viewModel)
            
        }.background(Color(Theme.backgroundColor))
    }
}

// MARK: - Xcode Previews

#if DEBUG
struct PhotoDetailsContainerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoDetailsContainerView(PhotoDetailsView_Preview_Helpers.photoViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
                .environment(\.colorScheme, .dark)

           PhotoDetailsContainerView(PhotoDetailsView_Preview_Helpers.photoViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
                .environment(\.colorScheme, .light)
        }
    }
}
#endif
