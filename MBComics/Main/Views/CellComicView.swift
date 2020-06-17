//
//  CellComicView.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Cosmos

class CellComicView: UIView {
    // MARK: - Outlets
    private let img = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleToFill
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    private let ratingPoint = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private let rating = CosmosView().then {
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
    
    private let ratingCount = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    private let favoriteBtn = UILabel().then {
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.text = "LIKE"
        $0.font = UIFont.systemFont(ofSize: 15,
                                    weight: UIFont.Weight(rawValue: 10))
        $0.textColor = .white
    }
    
    // MARK: - Values
    private var imgHeight = 0
    private var comicId = 0
    private let zeroStar = 0, oneStar = 1
    
    private var favoriteState = false
    var onTapFavorite: ((Int, Bool) -> Void)?
    var onRatingLoaded: ((ComicRateInfo) -> Void)?
    
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
    
    func initData(imgHeight: Int, comic: Comic) {
        self.imgHeight = imgHeight
        img.kf.setImage(with: URL(string: comic.poster), options: [.requestModifier(kKfModifier)])
        titleLabel.text = comic.title
        if let homeComic = comic as? HomeComic {
            subTitleLabel.text = homeComic.issueName
        }
        
        [rating, ratingCount, ratingPoint].forEach { $0.isHidden = comic is FavoriteComic }
        rating.rating = comic.ratingInfo.ratePoint
        switch comic.ratingInfo.rateCount {
        case zeroStar:
            ratingCount.text = "Not Enough Ratings"
            ratingPoint.text = "0"
        case oneStar:
            ratingPoint.text = String(comic.ratingInfo.ratePoint)
            ratingCount.text = "1 Rating"
        default:
            ratingPoint.text = String(comic.ratingInfo.ratePoint)
            ratingCount.text = String(format: "%d Ratings", comic.ratingInfo.rateCount)
        }
        
        comicId = comic.id
        if let currentUser = AppInfo.currentUser {
            favoriteState = (currentUser.favoriteComics.map { $0.id }).contains(comicId)
        }

        updateFavoriteBtn()
        initLayout()
    }

    private func initLayout() {
        setImgLayout()
        setTitleLayout()
        if let text = subTitleLabel.text, !text.isEmpty {
            setSubTitleLayout()
        }
        setRatingLayout()
        setRatingCountLayout()
        setRatingPointLayout()
        setFavoriteBtnLayout()
        
        addGestures()
    }
    
    private func updateFavoriteBtn() {
        favoriteBtn.do {
            $0.backgroundColor = favoriteState ? .systemBlue : .darkGray
            $0.text = favoriteState ? "LIKED" : "LIKE"
        }
    }
    
    private func addGestures() {
        favoriteBtn.addTapGesture(target: self, action: #selector(tapFavoriteBtn))
    }
    
    // MARK: set Sub-Layout
    private func setImgLayout() {
        img.snp.makeConstraints {
           $0.left.equalTo(self)
           $0.top.equalTo(self)
           $0.bottom.equalTo(self)
           $0.width.equalTo(imgHeight*3/4)
           $0.height.equalTo(imgHeight)
        }
    }
    
    private func setTitleLayout() {
        titleLabel.snp.makeConstraints {
           $0.left.equalTo(img.snp.right).offset(10)
           $0.right.equalTo(self)
           $0.top.equalTo(self)
        }
    }
    
    private func setSubTitleLayout() {
        subTitleLabel.snp.makeConstraints {
           $0.left.equalTo(img.snp.right).offset(10)
           $0.right.equalTo(self)
           $0.top.equalTo(titleLabel.snp.bottom).offset(1)
        }
    }
    
    private func setRatingPointLayout() {
        ratingPoint.snp.makeConstraints {
           $0.left.equalTo(img.snp.right).offset(10)
        }
    }
    
    private func setRatingCountLayout() {
        ratingCount.snp.makeConstraints {
           $0.left.equalTo(img.snp.right).offset(10)
           $0.top.equalTo(rating.snp.bottom).offset(1)
        }
    }
    
    private func setFavoriteBtnLayout() {
        favoriteBtn.snp.makeConstraints {
           $0.left.equalTo(img.snp.right).offset(10)
           $0.bottom.equalTo(img.snp.bottom)
           $0.top.lessThanOrEqualTo(ratingCount.snp.bottom).offset(30)
           $0.width.equalTo(80)
           $0.height.equalTo(30)
        }
    }
    
    private func setRatingLayout() {
        rating.snp.makeConstraints {
           $0.left.equalTo(ratingPoint.snp.right).offset(1)
           $0.centerY.equalTo(ratingPoint).offset(1)
           $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
    // MARK: - Actions
    @objc private func tapFavoriteBtn() {
        favoriteState = !favoriteState
        updateFavoriteBtn()
        onTapFavorite?(comicId, favoriteState)
    }
}
