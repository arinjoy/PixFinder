//
//  SearchPlaceholderViewController.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

final class SearchPlaceholderViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyles()
        configureAccessibility()
    }

    // MARK: - Public

    func showStartSearch() {
        render(viewModel: SearchPlaceholderViewModel.startSearch)
    }

    func showNoResults() {
        render(viewModel: SearchPlaceholderViewModel.noResults)
    }

    func showDataLoadingError() {
        render(viewModel: SearchPlaceholderViewModel.dataLoadingError)
    }

    // MARK: - Private Helpers
    
    private func render(viewModel: SearchPlaceholderViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.image = viewModel.image
    }

    private func applyStyles() {
        view.backgroundColor = Theme.secondaryBackgroundColor

        imageView.tintColor = Theme.primaryTextColor
        imageView.contentMode = .scaleAspectFit

        for label in [titleLabel, descriptionLabel] {
            label?.textColor = Theme.primaryTextColor
            label?.adjustsFontForContentSizeCategory = true
        }

        titleLabel.font = Theme.titleFont
        descriptionLabel.font = Theme.bodyFont
    }
    
    private func configureAccessibility() {
        view.accessibilityIdentifier = AccessibilityIdentifiers.SearchPlaceholder.rootViewId
        titleLabel.accessibilityIdentifier = AccessibilityIdentifiers.SearchPlaceholder.titleLabelId
        descriptionLabel.accessibilityIdentifier = AccessibilityIdentifiers.SearchPlaceholder.descriptionLabelId
        
        titleLabel.accessibilityTraits = .header
        descriptionLabel.accessibilityTraits = .staticText
        
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = .image
    }
}
