//
//  HomeTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

protocol HomeTBCellDelegate: class {
    func pushVCToComic(comicId: Int)
    func pushVCToAllComic(title: String?, comics: [HomeComic])
    func tapFavoriteComic(comicId: Int, state: Bool)
}

class HomeTBViewCell: BaseTBCell {
    
    // MARK: - Outlets
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
        HomeCLViewCell.registerCellByClass($0)
    }
    
    lazy var seeAllLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 14)
        $0.text = "See All"
        $0.addTapGesture(target: self, action: #selector(tapSeeAll))
    }
    
    var titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    // MARK: - Values
    weak var delegate: HomeTBCellDelegate?
    var cellIndexPath = 0
    var imgHeight = 0
    var comics = [HomeComic]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var numberCells: Int {
        return min(comics.count, 5)
    }
    
    // MARK: Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    func initData(imgHeight: Int, title: String, comics: [HomeComic]) {
        titleLabel.text = title
        self.imgHeight = imgHeight
        self.comics = comics
        setUpConstraints()
    }
    
    func setUpViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(seeAllLabel)
    }
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.right.equalTo(0)
            make.bottom.equalTo(-20)
            make.height.equalTo(imgHeight)
        }
        
        seeAllLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(titleLabel)
        }
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
        if cellIndexPath < numberCells - 1 {
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
            collectionView.scrollToItem(at: IndexPath(item: cellIndexPath,
                                                      section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
        }
    }
    
    // TODO: Add actions
    @objc func tapSeeAll() {
        delegate?.pushVCToAllComic(title: titleLabel.text, comics: comics)
    }
}

// MARK: - Collection View
extension HomeTBViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth - 2 * 20, height: CGFloat(imgHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = HomeCLViewCell.loadCell(collectionView, path: indexPath) as? HomeCLViewCell
        else { return BaseCLCell() }
        cell.initData(imgHeight: imgHeight,
                      comic: comics[indexPath.row],
                      onTapFavorite: delegate?.tapFavoriteComic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushVCToComic(comicId: comics[indexPath.row].id)
    }
}
