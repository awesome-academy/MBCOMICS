//
//  ComicDetailViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import SSPlaceHolderTableView

class ComicDetailViewController: BaseViewController {
    // MARK: - Outlets
    lazy var tableView = TableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.tableFooterView = UIView(frame: .zero)
        $0.showsVerticalScrollIndicator = false
        $0.refreshControl = refreshControl
        $0.delegate = self
        $0.dataSource = self
        
        HeaderComicTBViewCell.registerCellByClass($0)
        SummaryComicTBViewCell.registerCellByClass($0)
        InfoComicTBViewCell.registerCellByClass($0)
        HomeTBViewCell.registerCellByClass($0)
        ReviewTBViewCell.registerCellByClass($0)
    }
    
    private let refreshControl = UIRefreshControl().then {
        $0.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
    // MARK: - Values
    private let comicRepository = ComicRepository(api: APIService.shared)
    
    var comicId = 0
    private var comic: DetailComic?
    private var reviews = [ReviewComic]()
    private var ratingPoint: Double = 0
    private var ratingCount: Int = 0

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if comic == nil {
            getData()
        }
    }
    
    func setData(comicId: Int) {
        self.comicId = comicId
    }
    
    // MARK: - Layouts
    func setUpViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(tableView)
        tableView.networkUnReachableBlock = { [weak self] in
            self?.getData()
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.margins)
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
        comicRepository.getDetailComic(comicId: comicId) { [weak self] (error, comic) in
            DispatchQueue.main.async {
                self?.hidePopupLoading()
                self?.handleComicData(error: error,
                                      comic: comic)
            }
        }
    }
    
    func handleComicData(error: ErrorResponse?, comic: DetailComic?) {
        if let error = error {
            tableView.isHidden = false
            refreshControl.endRefreshing()
            
            let message = NSAttributedString(string: error.message)
            if error.type == .noInternet {
                tableView.setState(.checkInternetAvaibility(noInternetImg: nil,
                                                            noInternetLabelTitle: nil))
            } else {
                tableView.setState(.noDataAvailable(noDataImg: nil,
                                                    noDataLabelTitle: message))
            }
        } else {
            self.comic = comic
            tableView.setState(.dataAvailable(viewController: self))
            comicRepository.getReviews(of: comicId) { [weak self] (error, reviews) in
                self?.handleReviewsApi(error: error, reviews: reviews)
            }
        }
    }
    
    func handleReviewsApi(error: Error?, reviews: [ReviewComic]) {
        tableView.isHidden = false
        refreshControl.endRefreshing()
        
        if let error = error {
            showAlert(title: ErrorMessage.defaultTitle, message: error.localizedDescription)
        } else {
            self.reviews = reviews
            
            ratingCount = reviews.count
            ratingPoint = Double(reviews.reduce(0, { $0 + $1.ratePoint })) / Double(ratingCount)
            
            tableView.reloadData()
        }
    }
}

extension ComicDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comic == nil ? 0 : DetailCellIndex.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let comic = comic, let user = AppInfo.currentUser else { return BaseTBCell() }
        
        switch DetailCellIndex(rawValue: indexPath.item) ?? .headerIndex {
        case .headerIndex:
            guard let cell = HeaderComicTBViewCell.loadCell(tableView) as? HeaderComicTBViewCell else { return BaseTBCell() }
            cell.initData(imgHeight: kCLCellHeight, comic: comic)
            
            return cell
            
        case .summaryIndex:
            guard let cell = SummaryComicTBViewCell.loadCell(tableView) as? SummaryComicTBViewCell else { return BaseTBCell() }
            cell.initData(title: "Summary", summary: comic.summary)
            
            return cell
        
        case .reviewIndex:
            guard let cell = ReviewTBViewCell.loadCell(tableView) as? ReviewTBViewCell else { return BaseTBCell() }
            cell.initData(comicId: comicId,
                          cellHeight: kCLCellHeight2,
                          title: "Reviews",
                          reviews: reviews)
            cell.delegate = self
            
            return cell
            
        case .infoIndex:
            guard let cell = InfoComicTBViewCell.loadCell(tableView) as? InfoComicTBViewCell else { return BaseTBCell() }
            cell.initData(title: "Infomations",
                          data: comicRepository.getInfoTBData(comic: comic))
            
            return cell
            
        case .relatedIndex:
            guard let cell = HomeTBViewCell.loadCell(tableView) as? HomeTBViewCell else { return BaseTBCell() }
            cell.initData(imgHeight: kCLCellHeight,
                          title: "You may also like",
                          comics: comic.relatedComics)
            cell.separatorInset = UIEdgeInsets(top: 0,
                                               left: kScreenWidth,
                                               bottom: 0,
                                               right: 0)
            return cell
        }
    }
}

extension ComicDetailViewController: ReviewTBCellDelegate {
    func pushVCToListReview() {
        
    }
    
    func pushVCToWriteReView() {
        
    }
}
