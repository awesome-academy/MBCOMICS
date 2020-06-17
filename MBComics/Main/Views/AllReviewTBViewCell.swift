//
//  AllReviewTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/14/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class AllReviewTBViewCell: BaseTBCell {
    // MARK: - Outlets
    private let reviewContentView = ReviewContentCell()
    
    // MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(reviewContentView)
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    func initData(review: ReviewComic) {
        reviewContentView.initData(review: review)
    }

    private func setUpConstraints() {
        reviewContentView.snp.makeConstraints {
           $0.left.top.equalTo(20)
           $0.right.bottom.equalTo(-20)
           $0.height.greaterThanOrEqualTo(100)
        }
    }
}
