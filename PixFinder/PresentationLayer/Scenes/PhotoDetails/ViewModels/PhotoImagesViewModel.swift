//
//  PhotoImagesViewModel.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 15/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import Combine

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
