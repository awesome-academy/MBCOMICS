//
//  HeaderComicTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/10/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Cosmos
import FontAwesome_swift

protocol HeaderComicTBCellDelegate: class {
    func pushToListIssues()
    func tapFavorite(state: Bool)
}

class HeaderComicTBViewCell: BaseTBCell {
    
    // MARK: - Outlets
    var posterView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleToFill
    }
    
    var titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    var subTitleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .systemGray
    }
    
    var ratingPointLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    lazy var ratingView = CosmosView().then {
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
    
    var ratingCountLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    
    lazy var favoriteButton = UILabel().then {
        $0.text = String.fontAwesomeIcon(name: .heart)
        $0.font = favoriteNormalFont
        $0.textColor = .systemGray
        
        $0.addTapGesture(target: self, action: #selector(tapFavorite))
    }
    
    lazy var readButton = UILabel().then {
        $0.textColor = .white
        $0.backgroundColor = .systemBlue
        $0.text = "READ"
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.font = UIFont.systemFont(ofSize: 15,
                                    weight: UIFont.Weight(rawValue: 10))
        $0.addTapGesture(target: self, action: #selector(tapRead))
    }
    
    lazy var yearLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - Values
    weak var delegate: HeaderComicTBCellDelegate?
    
    var favoriteState = false {
        didSet {
            updateFavoriteBtn()
        }
    }
    
    private let favoriteNormalFont = UIFont.fontAwesome(ofSize: 25, style: .regular)
    private let favoriteSelectedFont = UIFont.fontAwesome(ofSize: 25, style: .solid)
    
    private let zeroStar = 0, oneStar = 1

    // MARK: - Life cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    func setUpViews() {
        selectionStyle = .none
        
        contentView.addSubviews([posterView,
                                 titleLabel,
                                 subTitleLabel,
                                 ratingView,
                                 ratingPointLabel,
                                 ratingCountLabel,
                                 favoriteButton,
                                 readButton,
                                 yearLabel])
        
        initLayout(imgHeight: kCLCellHeight)
    }
    
    func initData(imgHeight: Int, comic: DetailComic, ratingCount: Int, ratePoint: Double) {
        initLayout(imgHeight: imgHeight)
        posterView.kf.setImage(with: URL(string: comic.poster),
                               options: [.requestModifier(kKfModifier)])
        titleLabel.text = comic.title
        subTitleLabel.text = comic.publisher
        yearLabel.attributedText = setAttText(num: comic.status.stringValue, str: "Status")

        ratingView.rating = ratePoint
        if let currentUser = AppInfo.currentUser {
            favoriteState = (currentUser.favoriteComics.map { $0.id }).contains(comic.id)
        }
        
        switch ratingCount {
        case zeroStar:
            ratingCountLabel.text = "Not Enough Ratings"
            ratingPointLabel.text = "0"
            ratingView.rating = 0
        case oneStar:
            ratingPointLabel.text = String(ratePoint)
            ratingCountLabel.text = "1 Rating"
        default:
            ratingPointLabel.text = String(ratePoint)
            ratingCountLabel.text = String(format: "%d Ratings", ratingCount)
        }
        
        updateFavoriteBtn()
        updateImageHeight(imgHeight: imgHeight)
    }
    
    func updateImageHeight(imgHeight: Int) {
        posterView.snp.updateConstraints {
            $0.width.equalTo(imgHeight*3/4)
            $0.height.equalTo(imgHeight)
        }
    }
    
    // MARK: - Layouts
    private func initLayout(imgHeight: Int) {
        setImgLayout(imgHeight: imgHeight)
        setTitleLayout()
        setSubTitleLayout()
        setRatingLayout()
        setRatingCountLayout()
        setRatingPointLayout()
        setReadButtonLayout()
        setFvrBtnLayout()
        setYearLabelLayout()
    }
    
    // MARK: - set Sub-Layout
    private func setImgLayout(imgHeight: Int) {
        posterView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(20)
            make.width.equalTo(imgHeight*3/4)
            make.height.equalTo(imgHeight)
        }
    }
    
    private func setTitleLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(posterView.snp.right).offset(15)
            make.right.equalTo(-20)
            make.top.equalTo(posterView.snp.top)
        }
    }
    
    private func setSubTitleLayout() {
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(posterView.snp.right).offset(15)
            make.right.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
        }
    }
    
    private func setReadButtonLayout() {
        readButton.snp.makeConstraints { make in
            make.left.equalTo(posterView.snp.right).offset(15)
            make.bottom.equalTo(posterView.snp.bottom)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    private func setFvrBtnLayout() {
        favoriteButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.bottom.equalTo(posterView.snp.bottom)
            make.height.equalTo(30)
        }
    }
    
    private func setRatingPointLayout() {
        ratingPointLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalTo(ratingView)
            make.top.equalTo(posterView.snp.bottom).offset(15)
        }
    }
    
    private func setRatingLayout() {
        ratingView.snp.makeConstraints { make in
            make.left.equalTo(ratingPointLabel.snp.right).offset(2)
//            make.top.equalTo(img.snp.bottom).offset(2)
        }
    }
    
    private func setRatingCountLayout() {
        ratingCountLabel.snp.makeConstraints { make in
            make.left.equalTo(ratingPointLabel.snp.left)
            make.top.equalTo(ratingView.snp.bottom)
            make.bottom.equalTo(-20)
        }
    }
    
    private func setYearLabelLayout() {
        yearLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(ratingPointLabel.snp.top)
        }
    }
    
    // MARK: - Actions
    private func updateFavoriteBtn() {
        favoriteButton.do {
            $0.textColor = favoriteState ? .systemRed : .systemGray
            $0.font = favoriteState ? favoriteSelectedFont : favoriteNormalFont
        }
    }
    
    @objc func tapFavorite() {
        favoriteState = !favoriteState
        updateFavoriteBtn()
        delegate?.tapFavorite(state: favoriteState)
    }
    
    @objc func tapRead() {
        delegate?.pushToListIssues()
    }
    
    private func setAttText(num: String, str: String) -> NSAttributedString {
        let numAtt = NSMutableAttributedString(string: "\(num)\n",
                                               attributes: [.foregroundColor: UIColor.darkGray,
                                                            .font: UIFont.boldSystemFont(ofSize: 20)])
        let strAtt = NSAttributedString(string: str,
                                        attributes: [.foregroundColor: UIColor.systemGray,
                                                     .font: UIFont.boldSystemFont(ofSize: 14)])
        numAtt.append(strAtt)
        
        return numAtt
    }
}
