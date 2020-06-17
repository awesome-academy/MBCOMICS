//
//  SearchViewController.swift
//  MBComics
//
//  Created by HoaPQ on 5/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import SSPlaceHolderTableView

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.delegate = self
        $0.dimsBackgroundDuringPresentation = false
    }
    
    private lazy var tableView = TableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.tableFooterView = UIView(frame: .zero)
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        AllComicTBViewCell.registerCellByClass($0)
    }
    
    // MARK: - Values
    private var searchResults = [SearchComic]() {
        didSet {
            if searchResults.isEmpty {
                tableView.setState(.noDataAvailable(noDataImg: nil,
                                                    noDataLabelTitle: nil))
            } else {
                tableView.setState(.dataAvailable(viewController: self))
            }
            tableView.reloadData()
        }
    }
    
    private let comicRepository = ComicRepository(api: APIService.shared)
    private let userRepository = UserRepository(api: APIService.shared)
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: - Layouts
    private func setUpViews() {
        view.backgroundColor = .white
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.margins)
        }
    }
    
    // MARK: - Actions
    private func getData(title: String?) {
        guard let text = title else { return }
        showPopupLoading()
        comicRepository.searchByName(of: text) { [weak self] (error, comics) in
            DispatchQueue.main.async {
                self?.handleSearchApi(error: error, comics: comics)
            }
        }
    }
    
    private func handleSearchApi(error: ErrorResponse?, comics: [SearchComic]) {
        hidePopupLoading()
        if let error = error {
            let message = NSAttributedString(string: error.message)
            if error.type == .noInternet {
                tableView.setState(.checkInternetAvaibility(noInternetImg: nil,
                                                            noInternetLabelTitle: nil))
            } else {
                tableView.setState(.noDataAvailable(noDataImg: nil,
                                                    noDataLabelTitle: message))
            }
        } else {
            self.getRatingInfos(for: comics)
        }
    }
    
    private func getRatingInfos(for comics: [SearchComic]) {
        if comics.isEmpty {
            searchResults = comics
            return
        }
        comicRepository.getReviewInfo(of: comics) { [weak self] (results) in
            if let results = results as? [SearchComic] {
                self?.searchResults = results
            }
        }
    }
    
    private func tapFavoriteComic(comicId: Int, state: Bool) {
        if let comic = (searchResults.filter { $0.id == comicId }).first {
            let favoriteComic = FavoriteComic(id: comic.id,
                                              title: comic.title,
                                              poster: comic.poster)
            if state {
                userRepository.addFavoriteComic(comic: favoriteComic)
            } else {
                userRepository.removeFavoriteComic(comic: favoriteComic)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = AllComicTBViewCell.loadCell(tableView) as? AllComicTBViewCell else { return BaseTBCell() }
        cell.initData(imgHeight: kCLCellHeight,
                      comic: searchResults[indexPath.item],
                      onTapFavorite: tapFavoriteComic)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ComicDetailViewController()
        detailVC.setData(comicId: searchResults[indexPath.row].id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getData(title: searchBar.text)
    }
}
