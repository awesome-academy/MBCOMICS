//
//  ReviewCLViewCell.swift
//  project2
//
//  Created by Macintosh on 6/9/19.
//  Copyright © 2019 HoaPQ. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCLViewCell: BaseCLCell {
    
    // MARK: - Outlets
    var reviewContentCell = ReviewContentCell()
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(reviewContentCell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(review: ReviewComic) {
        reviewContentCell.initData(review: review)
        
        initLayout()
    }

    // MARK: - Layouts
    func initLayout() {
        reviewContentCell.snp.makeConstraints {
           $0.edges.equalToSuperview()
        }
    }
}
