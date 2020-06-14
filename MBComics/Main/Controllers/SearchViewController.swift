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
        }
    }
    
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
        // TODO: API
    }
    
    private func tapFavoriteComic(comicId: Int, state: Bool) {
        // TODO: API
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
