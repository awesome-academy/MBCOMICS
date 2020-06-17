//
//  SumaryComicTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/10/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class SummaryComicTBViewCell: BaseTBCell {
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
    }
    
    lazy var summaryLabel = UILabel().then {
        $0.font = .italicSystemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.do {
            $0.addSubview(titleLabel)
            $0.addSubview(summaryLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(title: String, summary: String) {
        titleLabel.text = title
        summaryLabel.text = summary
        
        initLayout()
    }

    func initLayout() {
        titleLabel.snp.makeConstraints {
           $0.left.top.equalTo(20)
        }
        
        summaryLabel.snp.makeConstraints {
           $0.left.equalTo(20)
           $0.right.bottom.equalTo(-20)
           $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
}
