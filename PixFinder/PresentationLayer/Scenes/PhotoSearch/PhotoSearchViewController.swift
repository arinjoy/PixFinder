//
//  PhotoSearchViewController.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import Combine

final class PhotoSearchViewController: UIViewController {

    private var cancellables: [AnyCancellable] = []

    // TODO: use for testing network layer works
    private let useCase: PhotosUseCaseType = PhotosUseCase(networkService: ServicesProvider.defaultProvider().network)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.yellow

        // TODO: Replace this below via ViewModel data binding to Collection View

         useCase.searchPhotos(with: "cat")
        .sink { (result: Result<[Photo], Error>) in
            switch result {
            case .success(let photos): print(photos)
            case .failure(let error): print(error)
            }
        }.store(in: &cancellables)
    }

}

