//
//  ListIssuesViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class ListIssuesViewController: UIViewController {

    // MARK: - Outlets
    lazy var tableView = UITableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.tableFooterView = UIView(frame: .zero)
        $0.showsVerticalScrollIndicator = false
        
        BaseTBCell.registerCellByClass($0)
    }
    
    // MARK: - Values
    var issues = [Issue]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    func setData(comicTitle: String, issues: [Issue]) {
        title = comicTitle
        self.issues = issues
    }
    
    // MARK: - Layouts
    func setUpViews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.margins)
        }
    }
}

extension ListIssuesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTBCell.loadCell(tableView)
        cell.initData(title: issues[indexPath.row].title, detail: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readingVC = ReadingViewController()
        
        navigationController?.pushViewController(readingVC, animated: true)
    }
}
