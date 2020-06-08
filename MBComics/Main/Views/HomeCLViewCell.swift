//
//  HomeCLViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class HomeCLViewCell: BaseCLCell {
    
    // MARK: - Outlets
    var cellComicView = CellComicView()
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellComicView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    func initData(imgHeight: Int, comic: HomeComic, onTapFavorite: ((Int, Bool) -> Void)?) {
        cellComicView.initData(imgHeight: imgHeight, comic: comic)
        cellComicView.onTapFavorite = onTapFavorite
        setUpConstraints()
    }
    
    func setUpConstraints() {
        cellComicView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
