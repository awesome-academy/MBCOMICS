//
//  ReviewContentCell.swift
//  ComicLife(project2.3)
//
//  Created by Macintosh on 6/10/19.
//  Copyright © 2019 Macintosh. All rights reserved.
//

import Cosmos

class ReviewContentCell: UIView {
    
    // MARK: - Outlets
    lazy var infoReviewLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
    
    lazy var ratingView = CosmosView().then {
        var options = CosmosSettings()
        options.updateOnTouch = false
        options.starSize = 20
        options.fillMode = .full
        options.starMargin = 1
        options.filledColor = .orange
        options.emptyBorderColor = .orange
        options.filledBorderColor = .orange
        
        $0.settings = options
    }
    
    lazy var commentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .groupTableViewBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubview(commentLabel)
        addSubview(infoReviewLabel)
        addSubview(ratingView)
        
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(review: ReviewComic) {
        ratingView.rating = Double(review.ratePoint)
        commentLabel.text = review.content
        
        let date = review.reviewAt.toReviewDateString()
        
        infoReviewLabel.text = "\(date)\n\(review.user.displayName)"
    }
    
    // MARK: - Layouts
    func initLayout() {
        infoReviewLabel.snp.makeConstraints {
           $0.top.equalTo(10)
           $0.right.equalTo(-10)
           $0.centerY.equalTo(ratingView)
        }
        
        ratingView.snp.makeConstraints {
           $0.left.equalTo(10)
        }
        
        commentLabel.snp.makeConstraints {
           $0.left.equalTo(ratingView.snp.left)
           $0.right.equalTo(infoReviewLabel.snp.right)
           $0.top.equalTo(infoReviewLabel.snp.bottom).offset(10)
        }
    }
}
