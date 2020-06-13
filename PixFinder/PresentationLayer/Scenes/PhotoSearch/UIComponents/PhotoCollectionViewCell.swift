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
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userAvatarImageView: UIImageView!
    @IBOutlet private weak var tagsLabel: UILabel!
    @IBOutlet private weak var likesIconView: UIImageView!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var commentsIconView: UIImageView!
    @IBOutlet private weak var commentsLabel: UILabel!
    @IBOutlet private weak var favouritesIconView: UIImageView!
    @IBOutlet private weak var favouritesLabel: UILabel!
    @IBOutlet private weak var downloadsIconView: UIImageView!
    @IBOutlet private weak var downloadsLabel: UILabel!

    // MARK: - Private Propertie

    private var mainImageCancellable: AnyCancellable?
    private var userAvatarImageCancellable: AnyCancellable?

    // MARK: - Lifecyle

    override func prepareForReuse() {
        super.prepareForReuse()

        cancelMainImageLoading()
        cancelUserAvatarImageLoading()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        userAvatarImageView.image = UIImage(named: "user-avatar")
        likesIconView.image = UIImage(named: "speech-bubble")
        commentsIconView.image = UIImage(named: "like-up")
        favouritesIconView.image = UIImage(named: "heart-love")
        downloadsIconView.image = UIImage(named: "download")

        applyStyles()
    }

    // MARK: - Configuration

    func configure(with viewModel: PhotoViewModel) {

        userNameLabel.text = viewModel.postedByUser.name
        tagsLabel.text = viewModel.tags

        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        favouritesLabel.text = viewModel.favourites
        downloadsLabel.text = viewModel.downloads

        mainImageCancellable = viewModel.mainImage
            .receive(on: Scheduler.main)
            .sink { [unowned self] image in
                self.showMainImage(image: image)
            }

        userAvatarImageCancellable = viewModel.userAvatarImage
            .receive(on: Scheduler.main)
            .sink { [unowned self] image in
                self.showUserAvatarImage(image: image)
            }
    }

     func showMainImage(image: UIImage?) {
        cancelMainImageLoading()

        UIView.transition(
            with: mainImageView,
            duration: 0.3,
            options: [.curveEaseOut, .transitionCrossDissolve],
            animations: {
                self.mainImageView.image = image
            })
    }

     func showUserAvatarImage(image: UIImage?) {
        cancelUserAvatarImageLoading()

        UIView.transition(
            with: userAvatarImageView,
            duration: 0.3,
            options: [.curveEaseOut, .transitionCrossDissolve],
            animations: {
                self.userAvatarImageView.image = image
            })
    }

    // MARK: - Private Helpers

    private func applyStyles() {
        self.backgroundColor = .clear
        containerView.backgroundColor = Theme.secondaryBackgroundColor
        mainImageView.backgroundColor = Theme.tertiaryBackgroundColor

        userNameLabel.numberOfLines = 1
        tagsLabel.lineBreakMode = .byTruncatingTail
        userNameLabel.adjustsFontForContentSizeCategory = true
        userNameLabel.font = Theme.subheadingFont
        
        tagsLabel.numberOfLines = 1
        tagsLabel.lineBreakMode = .byWordWrapping
        tagsLabel.font = Theme.bodyFont
        tagsLabel.adjustsFontForContentSizeCategory = true

        for label in [likesLabel,
                      commentsLabel,
                      favouritesLabel,
                      downloadsLabel] {
            label?.font = Theme.footnoteFont
            label?.adjustsFontForContentSizeCategory = true
            label?.numberOfLines = 1
        }

        userAvatarImageView.tintColor = Theme.tertiaryBackgroundColor
        userAvatarImageView.contentMode = .scaleAspectFit

        for imageView in [likesIconView,
                          commentsIconView,
                          favouritesIconView,
                          downloadsIconView] {
            imageView?.tintColor = Theme.primaryTextColor
            imageView?.contentMode = .scaleAspectFit
        }

        applyContainerShadowStyle()
    }

    private func applyContainerShadowStyle() {
        let shadow = Shadow(color: Theme.primaryTextColor,
                            opacity: 0.4,
                            blur: 4,
                            offset: CGSize(width: 0, height: 0))
        shadow.apply(toView: self)

        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8.0

        userAvatarImageView.layer.masksToBounds = true
        userAvatarImageView.layer.borderWidth = 2.0
        userAvatarImageView.layer.borderColor = Theme.tertiaryBackgroundColor.cgColor
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.bounds.width / 2
    }

    private func cancelMainImageLoading() {
        mainImageView.image = nil
        mainImageCancellable?.cancel()
    }

    private func cancelUserAvatarImageLoading() {
        userAvatarImageView.image = UIImage(named: "user-avatar")
        userAvatarImageCancellable?.cancel()
    }
}
