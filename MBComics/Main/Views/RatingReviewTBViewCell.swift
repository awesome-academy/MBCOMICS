//
//  RatingReviewTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/14/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Cosmos

protocol FormCellType {
    var title: String { get set }
    var onUpdateValue: ((String, Any?) -> Void)? { get set }
}

class RatingReviewTBViewCell: BaseTBCell, FormCellType {
    
    var onUpdateValue: ((String, Any?) -> Void)?
    
    private lazy var rating = CosmosView().then {
        var options = CosmosSettings()
        options.updateOnTouch = true
        options.starSize = 30
        options.fillMode = .full
        options.starMargin = 3
        options.filledColor = .systemBlue
        options.emptyBorderColor = .systemBlue
        options.filledBorderColor = .systemBlue
        
        $0.settings = options
        $0.rating = 0
        
        $0.didFinishTouchingCosmos = { [weak self] ratingPoint in
            self?.onTapRating(value: ratingPoint)
        }
    }
    
    private lazy var tapToRateLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.text = "Tap to Rate:"
        $0.font = .systemFont(ofSize: 16)
    }
    
    var title = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(rating)
        self.contentView.addSubview(tapToRateLabel)
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(title: String, initialRating: Int = 0) {
        rating.rating = Double(initialRating)
        self.title = title
        onUpdateValue?(title, initialRating)
    }
    
    private func initLayout() {
        self.tapToRateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(rating)
        }
        self.rating.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(20)
            make.bottom.equalTo(-20)
        }
    }
    
    private func onTapRating(value: Double) {
        if value > 0 {
            onUpdateValue?(title, value)
        } else {
            onUpdateValue?(title, nil)
        }
    }
}
