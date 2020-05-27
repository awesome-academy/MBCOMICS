//
//  SearchViewController.swift
//  MBComics
//
//  Created by HoaPQ on 5/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
        
    // MARK: - Outlets
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        return searchController
    }()

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
    }

    // MARK: - Layouts
    func setUpViews() {
        view.backgroundColor = .white
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.searchController = searchController
    }

    func updateSearchResults(for searchController: UISearchController) {
        
    }

}
