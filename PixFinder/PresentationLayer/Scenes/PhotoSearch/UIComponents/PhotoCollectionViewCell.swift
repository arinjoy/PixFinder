//
//  PhotoCollectionViewCell.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import Combine

final class PhotoCollectionViewCell: UICollectionViewCell, NibProvidable, ReusableView {

    // MARK: - UI Elements / Outlets

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var tagsLabel: UILabel!

    // MARK: - Private Propertie

    private var cancellable: AnyCancellable?

    // MARK: - Lifecyle

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Configuration

    func configure(with viewModel: Photo) {
        userNameLabel.text = viewModel.postedByUserName
        tagsLabel.text = viewModel.tags

        // TODO; bind this the image view
        print(viewModel.mediumSizeUrl)

    }
}
