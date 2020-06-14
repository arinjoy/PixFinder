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

    // MARK: UI Elements / Outlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = Theme.tintColor
        searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifiers.PhotoSearch.searchTextFieldId
        searchController.searchBar.delegate = self
        return searchController
    }()

    private lazy var searchPlaceholderViewController = {
        return SearchPlaceholderViewController(nibName: nil, bundle: nil)
    }()

    // MARK:- Private Properties

    /// Will be injected upon storyboard based intialisation, that's why not as `private let`
    /// TODO: Move to `one XIB` based `one VC` loading so that can be passed on `init(withViewModel:)` style
    var viewModel: PhotoSearchViewModelType!
    
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<PhotoViewModel, Never>()

    private var cancellables: [AnyCancellable] = []

    // MARK: - Image loading operations related

    private var imageLoadingQueue = OperationQueue()
    private var imageLoadingOperations: [IndexPath: ImageLoadOperation] = [:]
    private var imageStore: [IndexPath: UIImage?] = [:]
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PhotoViewModel> = {
        return makeDataSource()
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureAccessibility()
        applyStyles()

        // Inject the placeholder view at start and prompt for search
        add(searchPlaceholderViewController)
        searchPlaceholderViewController.showStartSearch()

        // Reactive binding to view model to listen for search
        // events & results showing activities
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        appear.send(())
    }

    // MARK: - Private Helpers
    
    private func configureUI() {
        definesPresentationContext = true
        title = StringKeys.PixFinder.photoSearchNavigationTitle.localized()

        collectionView.registerNib(cellClass: PhotoCollectionViewCell.self)
        collectionView.collectionViewLayout = customPhotoGridLayout()
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        navigationItem.searchController = searchController
        searchController.isActive = true
    }

    private func bind(to viewModel: PhotoSearchViewModelType) {

        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input = PhotoSearchViewModelInput(appear: appear.eraseToAnyPublisher(),
                                              search: search.eraseToAnyPublisher(),
                                              selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output
            .receive(on: Scheduler.main)
            .sink(receiveValue: { [weak self] state in
                self?.render(state)
            }).store(in: &cancellables)
    }

    private func render(_ state: PhotoSearchState) {
        switch state {
        case .idle:
            searchPlaceholderViewController.view.isHidden = false
            searchPlaceholderViewController.showStartSearch()
            
            loadingView.isHidden = true
            update(with: [], animate: true)
        
        case .loading:
            searchPlaceholderViewController.view.isHidden = true
            
            loadingView.isHidden = false
            update(with: [], animate: true)
        
        case .noResults:
            searchPlaceholderViewController.view.isHidden = false
            searchPlaceholderViewController.showNoResults()
            
            loadingView.isHidden = true
            update(with: [], animate: true)
        
        case .failure(let error):
            searchPlaceholderViewController.view.isHidden = false
            // Note: Handle more and more custom error cases to tweak the
            // error message copy if needed
            switch error {
            case .networkFailure, .timeout:
                searchPlaceholderViewController.showConnectivityError()
            default:
                searchPlaceholderViewController.showGenericError()
            }

            loadingView.isHidden = true
            update(with: [], animate: true)
        
        case .success(let photos):
            searchPlaceholderViewController.view.isHidden = true
            
            loadingView.isHidden = true
            update(with: photos, animate: true)
        }
    }

    private func customPhotoGridLayout() -> UICollectionViewLayout {

        // TODO: improve it or customise as much as needed based on `layoutEnvironment.traitCollection`

        /**
         For all sorts of device class detection and custom size for the cells or number of rows or even randomize
         rows/columns in large iPad devices etc..

         Courtesy from Apple: https://developer.apple.com/videos/play/wwdc2019/215/
         */

        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            let isCompact = layoutEnvironment.traitCollection.horizontalSizeClass == .compact
            let itemCount = isCompact ? 1 : 3
            let itemHeight = isCompact ?
                UIScreen.main.bounds.width : UIScreen.main.bounds.width / CGFloat(itemCount) + 60
            let padding: CGFloat = isCompact ? 16 : 24
            
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(itemHeight))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                           subitem: item,
                                                           count: itemCount)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(padding)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: padding,
                                                            leading: padding,
                                                            bottom: padding,
                                                            trailing: padding)
            section.interGroupSpacing = padding
            return section
        })
    }

    private func applyStyles() {
        view.backgroundColor = Theme.secondaryBackgroundColor
        collectionView.backgroundColor = Theme.secondaryBackgroundColor
        loadingView.backgroundColor = Theme.secondaryBackgroundColor
        loadingActivityIndicator.color = Theme.tintColor
    }
    
    private func configureAccessibility() {
        view.accessibilityIdentifier = AccessibilityIdentifiers.PhotoSearch.rootViewId
        collectionView.accessibilityIdentifier = AccessibilityIdentifiers.PhotoSearch.collectionViewId
    }
}


extension PhotoSearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.send("")
    }
}

extension PhotoSearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        // Send reactive signal as selection is made and pass the photo view model being selected
        selection.send(snapshot.itemIdentifiers[indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCollectionViewCell else { return }

        // Check if image store has this image loaded already, then update using the same
        if let mainImage = viewModel.mainImageStore[indexPath] {
            cell.showMainImage(image: mainImage)
        } else {
            // Else, add image loading operation and attach the image update closure
            let updateCellClosure1: (UIImage?) -> Void = { [weak self] image in
                cell.showMainImage(image: image)
                self?.viewModel.mainImageStore[indexPath] = image
                self?.viewModel.removeImageLoadOperation(atIndexPath: indexPath,
                                                         forImageType: .mainPhoto)
            }
            viewModel.addImageLoadOperation(atIndexPath: indexPath,
                                            forImageType: .mainPhoto,
                                            updateCellClosure: updateCellClosure1)
        }

        // Same logic for user avatar images
        if let avatarImage = viewModel.avatarImageStore[indexPath] {
            cell.showUserAvatarImage(image: avatarImage)
        } else {
            // Else, add image loading operation and attach the image update closure
            let updateCellClosure2: (UIImage?) -> Void = { [weak self] image in
                cell.showUserAvatarImage(image: image)
                self?.viewModel.avatarImageStore[indexPath] = image
                self?.viewModel.removeImageLoadOperation(atIndexPath: indexPath,
                                                         forImageType: .userAvatar)
            }
            viewModel.addImageLoadOperation(atIndexPath: indexPath,
                                            forImageType: .userAvatar,
                                            updateCellClosure: updateCellClosure2)
        }
    }
}

// MARK: - Diffable DataSource & updates

extension PhotoSearchViewController {

    enum Section: CaseIterable {
        case photos
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, PhotoViewModel> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, photoViewModel in
                let cell = collectionView.dequeueReusableCell(withClass: PhotoCollectionViewCell.self,
                                                              forIndexPath: indexPath)
                cell.configure(with: photoViewModel)
                cell.accessibilityIdentifier = "\(AccessibilityIdentifiers.PhotoSearch.cellId).\(indexPath.row)"
                return cell
            }
        )
    }

    func update(with photos: [PhotoViewModel], animate: Bool = false) {        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(photos, toSection: .photos)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
