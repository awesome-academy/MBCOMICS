//
//  WriteReviewViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController {

    // MARK: - Outlets
    private lazy var tableView = UITableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.tableFooterView = UIView(frame: .zero)
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        RatingReviewTBViewCell.registerCellByClass($0)
        TextViewFormCell.registerCellByClass($0)
    }
    
    // MARK: - Values
    private var formValues = [String: Any?]()
    private var comicId: Int!
    private var initialRating = 0
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    func initData(comicId: Int, initialRating: Int = 0) {
        self.comicId = comicId
        self.initialRating = initialRating
    }
    
    // MARK: - Layouts
    private func setUpViews() {
        view.backgroundColor = .white
        title = "Write Review"
        
        navigationItem.do {
            $0.rightBarButtonItem = UIBarButtonItem(title: "Submit",
                                                                style: UIBarButtonItem.Style.plain,
                                                                target: self,
                                                                action: #selector(submitReview))
            $0.rightBarButtonItem?.isEnabled = false
            
            $0.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: self,
                                                               action: #selector(cancel))
        }
        view.backgroundColor = .white
        
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Actions
    @objc private func submitReview() {
        
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func onUpdateValue(title: String, value: Any?) {
        formValues[title] = value
        
        navigationItem.rightBarButtonItem?.isEnabled = validate()
    }
    
    private func validate() -> Bool {
        var result = true
        if formValues.count != ReviewField.totalFields {
            return false
        }
        formValues.forEach { ( _, value) in
            if value == nil {
                result = false
            }
        }
        
        return result
    }
}

extension WriteReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case ReviewField.ratePointIndex:
            guard let cell = RatingReviewTBViewCell.loadCell(tableView) as? RatingReviewTBViewCell else { return BaseTBCell() }
            cell.onUpdateValue = onUpdateValue
            cell.initData(title: ReviewField.ratePoint, initialRating: initialRating)
            return cell
        case ReviewField.contentIndex:
            guard let cell = TextViewFormCell.loadCell(tableView) as? TextViewFormCell else { return BaseTBCell() }
            cell.initData(title: ReviewField.content,
                          placeHolder: ReviewField.contentPlaceholder)
            cell.onUpdateValue = onUpdateValue
            
            return cell
        default:
            return BaseTBCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReviewField.totalFields
    }
}
