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

    /// Will be injected upon storyboard based intialisation, that's why not as `private let`
    /// TODO: Move to `one XIB` based `one VC` loading so that can be passed on `init(withViewModel:)` style
    var viewModel: PhotoSearchViewModelType!
    
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Int, Never>()

    private var cancellables: [AnyCancellable] = []

    // TODO: use for testing network layer works
    private let useCase: PhotosUseCaseType = PhotosUseCase(
        networkService: ServicesProvider.defaultProvider().network
    )

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PhotoViewModel> = {
        return makeDataSource()
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind(to: viewModel)
    }

    // MARK: - Private Helpers

    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Photos", comment: "top photos")

        collectionView.registerNib(cellClass: PhotoCollectionViewCell.self)
        collectionView.collectionViewLayout = customPhotoGridLayout()
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        navigationItem.searchController = self.searchController
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
            loadingView.isHidden = true
            update(with: [], animate: true)
        case .loading:
            loadingView.isHidden = false
            update(with: [], animate: true)
        case .noResults:
            loadingView.isHidden = true
            update(with: [], animate: true)
        case .failure:
            loadingView.isHidden = true
            update(with: [], animate: true)
        case .success(let photos):
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(photos, toSection: .photos)
        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
