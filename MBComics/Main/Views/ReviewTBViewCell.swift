//
//  ReviewTBViewCell.swift
//  project2
//
//  Created by Macintosh on 6/7/19.
//  Copyright © 2019 HoaPQ. All rights reserved.
//

import UIKit
import Cosmos
import SnapKit
import FontAwesome_swift

protocol ReviewTBCellDelegate: class {
    func pushVCToListReview()
    func pushVCToWriteReView(initialRating: Int)
}

class ReviewTBViewCell: BaseTBCell {
    
    // MARK: - Outlets
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private let statsView = ReviewStatsView().then {
        $0.clipsToBounds = true
    }
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: collectionViewLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        
        $0.dataSource = self
        $0.delegate = self
        ReviewCLViewCell.registerCellByClass($0)
        EmptyReviewCLViewCell.registerCellByClass($0)
    }
    
    private lazy var seeAllLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 14)
        $0.text = "See All"
        $0.addTapGesture(target: self, action: #selector(tapSeeAll))
    }
    
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
        $0.didFinishTouchingCosmos = { [weak self] (ratingPoint) in
            self?.delegate?.pushVCToWriteReView(initialRating: Int(ratingPoint))
        }
    }
    
    private lazy var tapToRateLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.text = "Tap to Rate:"
        $0.font = .systemFont(ofSize: 16)
    }
    
    private lazy var writeReviewLabel = UILabel().then {
        let icon = NSTextAttachment()
        icon.image = UIImage.fontAwesomeIcon(name: .commentDots,
                                             style: .regular,
                                             textColor: .systemBlue,
                                             size: CGSize(width: 30, height: 30))
        let attIcon = NSAttributedString(string: String.fontAwesomeIcon(name: .commentDots),
                                         attributes: [.font: UIFont.fontAwesome(ofSize: 14, style: .regular),
                                                      .foregroundColor: UIColor.systemBlue])
        let attText = NSAttributedString(string: " Write a Review",
                                         attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                      .foregroundColor: UIColor.systemBlue])
        let text = NSMutableAttributedString()
        text.append(attIcon)
        text.append(attText)

        $0.attributedText = text
        $0.addTapGesture(target: self, action: #selector(tapReview))
    }
    
    var statsViewHeightConstraint: Constraint?
    // MARK: - Values
    weak var delegate: ReviewTBCellDelegate?
    
    private var cellIndexPath = 0
    private var isInRecently = false
    private var cellHeight = 0
    private var reviews = [ReviewComic]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let cellSpacing: CGFloat = 10
    
    // MARK: - Life cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([titleLabel,
                                 statsView,
                                 collectionView,
                                 seeAllLabel,
                                 tapToRateLabel,
                                 rating,
                                 writeReviewLabel])

        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData(comicId: Int, cellHeight: Int, title: String, reviews: [ReviewComic]) {
        self.cellHeight = cellHeight
        self.reviews = reviews
        
        titleLabel.text = title
        isInRecently = true
        
        initLayout()
        updateView()
        let ratePoint = reviews.reduce(0.0, { $0 + Double($1.ratePoint) })
        if reviews.isEmpty {
            statsView.isHidden = true
            hideRateStats()
        } else {
            if let user = AppInfo.currentUser,
               let review = (reviews.filter { $0.user.uid == user.uid }).first {
                rating.rating = Double(review.ratePoint)
            }
            statsView.isHidden = false
            showRateStats()
            statsView.initData(reviews: reviews,
                               ratePoint: ratePoint/Double(reviews.count),
                               rateCount: reviews.count)
        }
    }
    
    // MARK: - Actions
    private func addGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        collectionView.addGestureRecognizer(swipeLeft)
        collectionView.addGestureRecognizer(swipeRight)
    }
    
    @objc private func swipeLeft() {
        if cellIndexPath < reviews.count - 1 {
            cellIndexPath += 1
            collectionView.scrollToItem(at: IndexPath(item: cellIndexPath,
                                                      section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
        }
        
    }
    @objc private func swipeRight() {
        if cellIndexPath > 0 {
            cellIndexPath -= 1
            collectionView.scrollToItem(at: IndexPath(item: self.cellIndexPath,
                                                      section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
        }
    }
    private func updateView() {
        rating.isHidden = !isInRecently
        tapToRateLabel.isHidden = !isInRecently
        writeReviewLabel.isHidden = !isInRecently
    }
    
    @objc private func tapSeeAll() {
        delegate?.pushVCToListReview()
    }
    
    @objc private func tapReview() {
        delegate?.pushVCToWriteReView(initialRating: 0)
    }

    // MARK: - setLayout
    private func initLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(20)
        }
        
        statsView.addLineToView(position: .bottom)
        
        tapToRateLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalTo(rating)
        }
        
        rating.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(statsView.snp.bottom).offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(rating.snp.bottom).offset(10)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(cellHeight)
        }
        
        seeAllLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(writeReviewLabel)
        }
        
        writeReviewLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.bottom.equalTo(-20)
        }
    }
    
    private func showRateStats() {
        statsView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    private func hideRateStats() {
        statsView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(0)
        }
    }
}

// MARK: - Datasource
extension ReviewTBViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth - 2 * 20,
                      height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return reviews.isEmpty ? 1 : reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !reviews.isEmpty {
            guard let cell = ReviewCLViewCell.loadCell(collectionView, path: indexPath) as? ReviewCLViewCell
                else { return BaseCLCell() }
            cell.initData(review: reviews[indexPath.row])
            
            return cell
            
        } else {
            guard let cell = EmptyReviewCLViewCell.loadCell(collectionView, path: indexPath) as? EmptyReviewCLViewCell
                else { return BaseCLCell() }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
