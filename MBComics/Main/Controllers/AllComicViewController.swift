//
//  AllComicViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class AllComicViewController: UIViewController {
    var comics = [HomeComic]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.tableFooterView = UIView(frame: .zero)
        AllComicTBViewCell.registerCellByClass($0)
        $0.showsVerticalScrollIndicator = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func initData(title: String?, comics: [HomeComic]) {
        self.title = title
        self.comics = comics
    }
    
    func setUpViews() {
        view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}

extension AllComicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = AllComicTBViewCell.loadCell(tableView) as? AllComicTBViewCell else { return BaseTBCell() }
        cell.initData(imgHeight: kCLCellHeight2, comic: comics[indexPath.row])
        
        if indexPath.row == comics.count {
            cell.separatorInset = UIEdgeInsets(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Add Action
    }
    
}
