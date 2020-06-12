//
//  ReviewTBViewCell.swift
//  project2
//
//  Created by Macintosh on 6/7/19.
//  Copyright © 2019 HoaPQ. All rights reserved.
//

import UIKit
import Cosmos
import FontAwesome_swift

protocol ReviewTBCellDelegate: class {
    func pushVCToListReview()
    func pushVCToWriteReView()
}

class ReviewTBViewCell: BaseTBCell {
    
    // MARK: - Outlets
    var titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: collectionViewLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        
        $0.dataSource = self
        $0.delegate = self
        ReviewCLViewCell.registerCellByClass($0)
        EmptyReviewCLViewCell.registerCellByClass($0)
    }
    
    lazy var seeAllLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 14)
        $0.text = "See All"
        $0.addTapGesture(target: self, action: #selector(tapSeeAll))
    }
    
    lazy var rating = CosmosView().then {
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
        $0.didFinishTouchingCosmos = { (ratingPoint) in
            // TODO: Add Action
        }
    }
    
    lazy var tapToRateLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.text = "Tap to Rate:"
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var writeReviewLabel = UILabel().then {
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
    
    // MARK: - Values
    weak var delegate: ReviewTBCellDelegate?
    
    var cellIndexPath = 0
    var isInRecently = false
    var cellHeight = 0
    var reviews = [ReviewComic]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let cellSpacing: CGFloat = 10
    
    // MARK: - Life cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([titleLabel,
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
    }
    
    // MARK: - Actions
    func addGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        collectionView.addGestureRecognizer(swipeLeft)
        collectionView.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipeLeft() {
        if cellIndexPath < reviews.count - 1 {
            cellIndexPath += 1
            collectionView.scrollToItem(at: IndexPath(item: cellIndexPath,
                                                      section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
        }
        
    }
    @objc func swipeRight() {
        if cellIndexPath > 0 {
            cellIndexPath -= 1
            collectionView.scrollToItem(at: IndexPath(item: self.cellIndexPath,
                                                      section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
        }
    }
    func updateView() {
        rating.isHidden = !isInRecently
        tapToRateLabel.isHidden = !isInRecently
        writeReviewLabel.isHidden = !isInRecently
    }
    
    @objc func tapSeeAll() {
        delegate?.pushVCToListReview()
    }
    
    @objc func tapReview() {
        delegate?.pushVCToWriteReView()
    }

    // MARK: - setLayout
    func initLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(rating.snp.bottom).offset(5)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(cellHeight)
        }
        
        seeAllLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(writeReviewLabel)
        }
        
        tapToRateLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalTo(rating)
        }
        
        rating.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
        }
        
        writeReviewLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.bottom.equalTo(-20)
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
