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

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = Theme.tintColor
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
    private let selection = PassthroughSubject<Int, Never>()

    private var cancellables: [AnyCancellable] = []

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
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        appear.send(())
    }

    // MARK: - Private Helpers

    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Pixabay photos", comment: "Pixabay photos")

        view.backgroundColor = Theme.secondaryBackgroundColor
        collectionView.backgroundColor = Theme.secondaryBackgroundColor

        collectionView.registerNib(cellClass: PhotoCollectionViewCell.self)
        collectionView.collectionViewLayout = customPhotoGridLayout()
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        navigationItem.searchController = searchController
        searchController.isActive = true

        add(searchPlaceholderViewController)
        searchPlaceholderViewController.showStartSearch()
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
        case .failure:
            searchPlaceholderViewController.view.isHidden = false
            searchPlaceholderViewController.showDataLoadingError()
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
        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
          let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
          let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 320 : 280)
          )
          let itemCount = isPhone ? 1 : 3
          let item = NSCollectionLayoutItem(layoutSize: size)
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
          let section = NSCollectionLayoutSection(group: group)
          section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
          section.interGroupSpacing = 10
          return section
        })
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
        // Send reactive signal as selection made
        selection.send(snapshot.itemIdentifiers[indexPath.row].id)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCollectionViewCell else { return }

        // Check if image store has this image loaded already, then update using the same
        if let image = imageStore[indexPath] {
            cell.showImage(image: image)
        } else {
            // Else, add image loading operation and attach the image update closure
            let updateCellClosure: (UIImage?) -> Void = { [weak self] image in
                cell.showImage(image: image)
                self?.imageStore[indexPath] = image
                self?.removeImageLoadOperation(atIndexPath: indexPath)
            }
            addImageLoadOperation(atIndexPath: indexPath, updateCellClosure: updateCellClosure)
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
                return cell
            }
        )
    }

    func update(with photos: [PhotoViewModel], animate: Bool = false) {

        // Clear any existing image loading operations and image store
        resetAllImageLoaders()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(photos, toSection: .photos)
        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

extension PhotoSearchViewController {

    func addImageLoadOperation(atIndexPath indexPath: IndexPath, updateCellClosure: ((UIImage?) -> Void)?) {

        // If an image loader exists for this indexPath, do not add it again
        guard imageLoadingOperations[indexPath] == nil else { return }

        // Find the web Url of the rquired indexPath from the data source

        if let photoViewModel = dataSource.itemIdentifier(for: indexPath) as PhotoViewModel? {

            // Create an image loader for the medium size URL
            let imageLoader = ImageLoadOperation(withUrl: photoViewModel.imageUrls.mediumSize)

            // Attach completion closure when data arrives to update cell
            imageLoader.completionHandler = updateCellClosure

            imageLoadingQueue.addOperation(imageLoader)
            imageLoadingOperations[indexPath] = imageLoader
        }
    }

    func removeImageLoadOperation(atIndexPath indexPath: IndexPath) {

        // If there's a image loader for this index path and we don't
        // need it any more, then Cancel and Dispose
        if let imageLoader = imageLoadingOperations[indexPath] {
            imageLoader.cancel()
            imageLoadingOperations.removeValue(forKey: indexPath)
        }
    }

    private func resetAllImageLoaders() {
        for (indexPath, _) in imageLoadingOperations {
            removeImageLoadOperation(atIndexPath: indexPath)
        }
        imageStore = [:]
    }
}
