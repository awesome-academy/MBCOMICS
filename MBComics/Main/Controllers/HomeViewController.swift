//
//  HomeViewController.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    lazy var tableView = UITableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.delegate = self
        $0.dataSource = self
        HomeTBViewCell.registerCellByClass($0)
        $0.separatorStyle = .none
        $0.tableFooterView = UIView(frame: .zero)
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Values
    var newestComics = [HomeComic]()
    var popularComics = [HomeComic]()

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }

    // MARK: - Layouts
    func setUpViews() {
        view.backgroundColor = .white
        title = "MBComics"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    func getData() {
        // Fake data
        guard let encodedString = kComicJson.data(using: .utf8),
              let json = try? JSON(data: encodedString) else { return }
        popularComics = Array(repeating: HomeComic(json), count: 10)
        newestComics = Array(repeating: HomeComic(json), count: 10)
        
        tableView.reloadData()
    }
    
    // TODO: Add API
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kNumberHomeSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = HomeTBViewCell.loadCell(self.tableView) as? HomeTBViewCell else { return BaseTBCell() }
        
        switch indexPath.item {
        case kPopularIndexPath:
            cell.initData(imgHeight: kCLCellHeight, title: "Top Read Comics", comics: popularComics)
           
        case kNewestIndexPath:
            cell.initData(imgHeight: kCLCellHeight, title: "Newest Comics", comics: newestComics)
        default:
            break
        }
        
        cell.delegate = self
        
        return cell
    }
}

extension HomeViewController: HomeTBCellDelegate {
    func pushVCToComic(comicId: Int) {
        let detailVC = ComicDetailViewController()
        detailVC.setData(comicId: comicId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func pushVCToAllComic(title: String?, comics: [HomeComic]) {
        let allComicsVC = AllComicViewController()
        allComicsVC.initData(title: title, comics: comics)
        navigationController?.pushViewController(allComicsVC, animated: true)
    }
    
    func tapFavoriteComic(comicId: Int, state: Bool) {
        // TODO: Add API
    }
}
