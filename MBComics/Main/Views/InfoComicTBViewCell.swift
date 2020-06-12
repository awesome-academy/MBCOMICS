//
//  InfoComicTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/10/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class InfoComicTBViewCell: BaseTBCell {
    var data = [LineInfoComic]() {
        didSet {
            updateData()
        }
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    lazy var stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(title: String, data: [LineInfoComic]) {
        self.titleLabel.text = title
        self.data = data
        
        initLayout()
    }
    
    private func updateData() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        data.enumerated().forEach { (index, item) in
            let infoView = LineInfoComicTBViewCell()
            infoView.initData(title: item.title, detail: item.detail)
            if index != data.count - 1 {
                infoView.addLineToView(position: .bottom)
            }
            stackView.addArrangedSubview(infoView)
        }
    }
    
    func initLayout() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(20)
        }
        self.stackView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-20)
        }
    }
}
