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
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.delegate = self
        return searchController
    }()

    // MARK:- Private Properties

    private var cancellables: [AnyCancellable] = []

    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()

    // TODO: use for testing network layer works
    private let useCase: PhotosUseCaseType = PhotosUseCase(
        networkService: ServicesProvider.defaultProvider().network
    )

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Photo> = {
        return makeDataSource()
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        // TODO: Replace this below via ViewModel data binding to Collection View

        useCase.searchPhotos(with: "cat")
        .sink { [weak self] result in
            switch result {
            case .success(let photos):
                self?.loadingView.isHidden = true
                self?.update(with: photos)
            case .failure(let error):
                print(error)
            }
        }.store(in: &cancellables)
    }

    // MARK: - Private Helpers

    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Photos", comment: "top photos")

        collectionView.registerNib(cellClass: PhotoCollectionViewCell.self)
        collectionView.dataSource = dataSource

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
          let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
          let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
          )
          let itemCount = isPhone ? 1 : 3
          let item = NSCollectionLayoutItem(layoutSize: size)
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
          let section = NSCollectionLayoutSection(group: group)
          section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
          section.interGroupSpacing = 10
          return section
        })

        navigationItem.searchController = self.searchController
        searchController.isActive = true

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

extension PhotoSearchViewController {

    enum Section: CaseIterable {
        case photos
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Photo> {
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

    func update(with photos: [Photo], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(photos, toSection: .photos)
        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
