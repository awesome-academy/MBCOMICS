//
//  ReviewStatsTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/14/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class ReviewStatsTBViewCell: BaseTBCell {
    // MARK: - Outlets
    private let statsView = ReviewStatsView()
    
    // MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(statsView)
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    func initData(reviews: [ReviewComic], ratePoint: Double, rateCount: Int) {
        statsView.initData(reviews: reviews,
                               ratePoint: ratePoint,
                               rateCount: rateCount)
    }

    private func setUpConstraints() {
        statsView.snp.makeConstraints {
           $0.left.top.equalTo(20)
           $0.right.bottom.equalTo(-20)
        }
    }
}
