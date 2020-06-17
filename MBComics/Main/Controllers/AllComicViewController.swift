//
//  AllComicViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class AllComicViewController: UIViewController {
    
    // MARK: - Outlets
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.tableFooterView = UIView(frame: .zero)
        AllComicTBViewCell.registerCellByClass($0)
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Values
    private let userRepository = UserRepository(api: APIService.shared)
    
    private var comics = [Comic]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func initData(title: String?, comics: [Comic]) {
        self.title = title
        self.comics = comics
    }
    
    // MARK: - Layouts
    private func setUpViews() {
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        tableView.snp.makeConstraints {
           $0.left.equalTo(0)
           $0.right.equalTo(0)
           $0.top.equalTo(0)
           $0.bottom.equalTo(0)
        }
    }
    
    private func tapFavoriteComic(comicId: Int, state: Bool) {
        guard let comic = comics.first(where: { $0.id == comicId }) else { return }
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

extension AllComicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = AllComicTBViewCell.loadCell(tableView) as? AllComicTBViewCell else { return BaseTBCell() }
        cell.initData(imgHeight: kCLCellHeight2,
                      comic: comics[indexPath.row],
                      onTapFavorite: tapFavoriteComic)
        
        if indexPath.row == comics.count {
            cell.separatorInset = UIEdgeInsets(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ComicDetailViewController()
        detailVC.setData(comicId: comics[indexPath.row].id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
