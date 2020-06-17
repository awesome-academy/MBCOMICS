//
//  LineInfoComicTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/10/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class LineInfoComicTBViewCell: UIView {
    lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    lazy var detailLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        initLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(title: String, detail: String) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
    
    func initLayout() {
        titleLabel.snp.makeConstraints {
           $0.left.top.equalTo(7)
           $0.width.equalToSuperview().multipliedBy(0.3)
           $0.height.equalTo(detailLabel.snp.height)
        }
        
        detailLabel.snp.makeConstraints {
           $0.right.bottom.equalToSuperview().offset(-7)
           $0.centerY.equalTo(titleLabel.snp.centerY)
           $0.width.equalToSuperview().multipliedBy(0.7)
        }
        
        snp.makeConstraints {
           $0.height.greaterThanOrEqualTo(44)
        }
    }
}
