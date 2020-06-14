//
//  HomeViewController.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import SwiftyJSON
import SSPlaceHolderTableView

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    private let refreshControl = UIRefreshControl().then {
        $0.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
    lazy var tableView = TableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.delegate = self
        $0.dataSource = self
        HomeTBViewCell.registerCellByClass($0)
        $0.separatorStyle = .none
        $0.tableFooterView = UIView(frame: .zero)
        $0.showsVerticalScrollIndicator = false
        $0.refreshControl = refreshControl
    }
    
    // MARK: - Values
    private let userRepository = UserRepository(api: APIService.shared)
    private let comicsRepository = ComicRepository(api: APIService.shared)
    
    var newestComics = [HomeComic]()
    var popularComics = [HomeComic]()

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userRepository.setUpCurrentUser()
        setUpViews()
        setUpConstraints()
        
        tableView.networkUnReachableBlock = { [weak self] in
            self?.getData()
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
    @objc func refreshData() {
        getData(type: .refresh)
    }
    
    func getData(type: APIType = .normal) {
        if type == .normal {
            tableView.isHidden = true
            showPopupLoading()
        }
        comicsRepository.getHomeComics { [weak self] (error, popular, newest) in
            DispatchQueue.main.async {
                self?.hidePopupLoading()
                self?.handleHomeApi(error: error,
                                    popularComics: popular,
                                    newestComics: newest)
            }
        }
    }
    
    func handleHomeApi(error: ErrorResponse?,
                       popularComics: [HomeComic],
                       newestComics: [HomeComic]) {
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
            self.newestComics = newestComics
            self.popularComics = popularComics
            self.getRatingInfos { [weak self] in
                self?.updateData()
            }
        }
    }
    
    private func getRatingInfos(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let tmpPopular = popularComics
        popularComics.removeAll()
        tmpPopular.forEach {
            var comic = $0
            group.enter()
            comicsRepository.getReviewInfo(of: comic.id) { [weak self] (info) in
                if let info = info {
                    comic.ratingInfo = info
                }
                self?.popularComics.append(comic)
                group.leave()
            }
        }
        
        let tmpNewsest = newestComics
        newestComics.removeAll()
        tmpNewsest.forEach {
            var comic = $0
            group.enter()
            comicsRepository.getReviewInfo(of: comic.id) { (info) in
                if let info = info {
                    comic.ratingInfo = info
                }
                self.newestComics.append(comic)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func updateData() {
        tableView.isHidden = false
        refreshControl.endRefreshing()
        tableView.setState(.dataAvailable(viewController: self))
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeCellIndex.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = HomeTBViewCell.loadCell(self.tableView) as? HomeTBViewCell else { return BaseTBCell() }
        switch HomeCellIndex(rawValue: indexPath.item) ?? .popularIndex {
        case .popularIndex:
            cell.initData(imgHeight: kCLCellHeight,
                          title: "Top Read Comics",
                          comics: popularComics)
           
        case .newestIndex:
            cell.initData(imgHeight: kCLCellHeight,
                          title: "Newest Comics",
                          comics: newestComics)
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
    
    func pushVCToAllComic(title: String?, comics: [Comic]) {
        let allComicsVC = AllComicViewController()
        allComicsVC.initData(title: title, comics: comics)
        navigationController?.pushViewController(allComicsVC, animated: true)
    }
    
    func tapFavoriteComic(comicId: Int, state: Bool) {
        if let comic = ((newestComics + popularComics).filter { $0.id == comicId }).first {
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
