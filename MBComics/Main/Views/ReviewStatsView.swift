//
//  ReviewStatsView.swift
//  MBComics
//
//  Created by HoaPQ on 6/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class ReviewStatsView: UIView {
    // MARK: - Outlets
    private lazy var rateLabel = UILabel().then {
        $0.text = "4.6"
        $0.font = .systemFont(ofSize: 50, weight: .heavy)
        $0.textColor = .systemGray
    }
    
    private lazy var outOfRateLabel = UILabel().then {
        $0.text = "out of 5"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .systemGray
    }
    
    private lazy var reviewCountLabel = UILabel().then {
        $0.text = "150 reviews"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .systemGray
    }
    
    private lazy var barChartView = StarBarView().then {
        $0.autoResize = true
        $0.backgroundBarColor = .groupTableViewBackground
        $0.barColor = .systemGray
        $0.contentSpace = 10
    }
    
    // MARK: - Values
    private let zeroStar = 0, oneStar = 1
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func initData(reviews: [ReviewComic], ratePoint: Double, rateCount: Int) {
        let arr = reviews.map { $0.ratePoint }
        var entries = [BarEntry]()
        var sumRating = 0
        for index in 1...5 {
            let entry = BarEntry(score: arr.filter { $0 == index }.count,
                                 title: Array(repeating: "⭑", count: index).reduce("", { $0 + $1 }))
            sumRating += index * entry.score
            entries.append(entry)
        }
        
        barChartView.dataEntries = entries.reversed()
        rateLabel.text = String(ratePoint.roundToPlaces(1))
        switch rateCount {
        case zeroStar:
            rateLabel.text = "Not Enough Ratings"
        case oneStar:
            reviewCountLabel.text = "1 Rating"
        default:
            reviewCountLabel.text = String(format: "%d Ratings", reviews.count)
        }
    }
    
    // MARK: - Layouts
    private func setUpViews() {
        addSubviews([rateLabel,
                     outOfRateLabel,
                     barChartView,
                     reviewCountLabel])
    }
    
    private func setUpConstraints() {
        rateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview()
        }
        
        outOfRateLabel.snp.makeConstraints {
            $0.top.equalTo(rateLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().offset(-10)
            $0.centerX.equalTo(rateLabel)
        }
        
        reviewCountLabel.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(outOfRateLabel)
        }
        
        barChartView.snp.makeConstraints {
            $0.top.height.equalTo(rateLabel)
            $0.left.equalTo(rateLabel.snp.right).offset(30)
            $0.right.equalToSuperview()
        }
    }
}
