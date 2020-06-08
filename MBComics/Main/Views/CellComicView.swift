//
//  CellComicView.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Cosmos

protocol ReloadTBVCellDelegate {
    func reloadCLVCell()
}

class CellComicView: UIView {
    // MARK: - Outlets
    var img = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleToFill
    }
    
    lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    var subTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    var ratingPoint = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    var rating = CosmosView().then {
        var options = CosmosSettings()
        options.updateOnTouch = false
        options.starSize = 20
        options.fillMode = .precise
        options.starMargin = 1
        options.filledColor = .darkGray
        options.emptyBorderColor = .darkGray
        options.filledBorderColor = .darkGray
        
        $0.settings = options
    }
    
    var ratingCount = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    var favoriteBtn = UILabel().then {
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.text = "LIKE"
        $0.font = UIFont.systemFont(ofSize: 15,
                                    weight: UIFont.Weight(rawValue: 10))
        $0.textColor = .white
    }
    
    // MARK: - Values
    var imgHeight = 0
    var comicId = 0
    
    var favoriteState = true
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(img)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(rating)
        addSubview(ratingPoint)
        addSubview(ratingCount)
        addSubview(favoriteBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(imgHeight: Int, comic: HomeComic) {
        self.imgHeight = imgHeight
        img.kf.setImage(with: URL(string: comic.poster), options: [.requestModifier(kKfModifier)])
        titleLabel.text = comic.title
        subTitleLabel.text = comic.issueName
        comicId = comic.id

        updateFavoriteBtn()
        initLayout()
    }

    func initLayout() {
        setImgLayout()
        setTitleLayout()
        if let text = subTitleLabel.text, !text.isEmpty {
            setSubTitleLayout()
        }
        setRatingLayout()
        setRatingCountLayout()
        setRatingPointLayout()
        setFavoriteBtnLayout()
    }
    
    func updateFavoriteBtn() {
        if favoriteState {
            favoriteBtn.backgroundColor = .systemBlue
        } else {
            favoriteBtn.backgroundColor = .darkGray
        }
    }
    
    // MARK: set Sub-Layout
    func setImgLayout() {
        img.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(imgHeight*3/4)
            make.height.equalTo(imgHeight)
        }
    }
    
    func setTitleLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(img.snp.right).offset(10)
            make.right.equalTo(self)
            make.top.equalTo(self)
        }
    }
    
    func setSubTitleLayout() {
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(img.snp.right).offset(10)
            make.right.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
        }
    }
    
    func setRatingPointLayout() {
        ratingPoint.snp.makeConstraints { make in
            make.left.equalTo(img.snp.right).offset(10)
        }
    }
    
    func setRatingCountLayout() {
        ratingCount.snp.makeConstraints { make in
            make.left.equalTo(img.snp.right).offset(10)
            make.top.equalTo(rating.snp.bottom).offset(1)
        }
    }
    
    func setFavoriteBtnLayout() {
        favoriteBtn.snp.makeConstraints { make in
            make.left.equalTo(img.snp.right).offset(10)
            make.bottom.equalTo(img.snp.bottom)
            make.top.lessThanOrEqualTo(ratingCount.snp.bottom).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    func setRatingLayout() {
        rating.snp.makeConstraints { make in
            make.left.equalTo(ratingPoint.snp.right).offset(1)
            make.centerY.equalTo(ratingPoint).offset(1)
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
    // TODO: Add Actions
    // MARK: - Actions
}
