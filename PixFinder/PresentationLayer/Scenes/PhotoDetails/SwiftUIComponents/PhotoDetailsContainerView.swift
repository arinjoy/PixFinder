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
            Image(uiImage: photoImagesViewModel.mainImage ?? UIImage(named: "photo-frame")!)
                   .aspectRatio(contentMode: .fit)
            
            DetailsTextualInfoView(viewModel)
        }
    }
}

struct PhotoDetailsContainerView_Previews: PreviewProvider {
    static var previews: some View {
        
    }
}
