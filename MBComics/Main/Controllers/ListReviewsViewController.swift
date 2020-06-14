//
//  ListReviewsViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class ListReviewsViewController: UIViewController {

    // MARK: - Outlets
    private lazy var tableView = UITableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.tableFooterView = UIView(frame: .zero)
        $0.showsVerticalScrollIndicator = false
        AllReviewTBViewCell.registerCellByClass($0)
        ReviewStatsTBViewCell.registerCellByClass($0)
    }
    
    // MARK: - Values
    private var reviews = [ReviewComic]()
    private var ratePoint = 0.0
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: - Layouts
    func setUpViews() {
        view.backgroundColor = .white
        title = "Reviews"
        view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func initData(reviews: [ReviewComic]) {
        self.reviews = reviews
        ratePoint = reviews.isEmpty ? 0.0 : Double(reviews.reduce(0, { $0 + $1.ratePoint })) / Double(reviews.count)
        tableView.reloadData()
    }
}

extension ListReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ListReview.totalSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == ListReview.statsSection ? 1 : reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case ListReview.statsSection:
            guard let cell = ReviewStatsTBViewCell.loadCell(tableView) as? ReviewStatsTBViewCell else { return BaseTBCell() }
            cell.initData(reviews: reviews,
                          ratePoint: ratePoint,
                          rateCount: reviews.count)
            
            return cell
        default:
            guard let cell = AllReviewTBViewCell.loadCell(tableView) as? AllReviewTBViewCell else { return BaseTBCell() }
            cell.initData(review: reviews[indexPath.item])
            
            return cell
        }
    }
}
