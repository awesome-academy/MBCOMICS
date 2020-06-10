//
//  AllComicTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class AllComicTBViewCell: BaseTBCell {
    // MARK: - Outlets
    var cellComicView = CellComicView()
    
    // MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellComicView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    func initData(imgHeight: Int, comic: Comic, onTapFavorite: ((Int, Bool) -> Void)?) {
        cellComicView.initData(imgHeight: imgHeight, comic: comic)
        cellComicView.onTapFavorite = onTapFavorite
        setUpConstraints()
    }

    func setUpConstraints() {
        cellComicView.snp.makeConstraints { make in
            make.left.top.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
    }
}
