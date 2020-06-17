//
//  UserInfoTBViewCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/8/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class UserInfoTBViewCell: BaseTBCell {
    
    // MARK: - Outlets
    lazy var avatarView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = CGFloat(imgHeight/2)
        $0.contentMode = .scaleToFill
    }
    
    var titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    var subTitleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    // MARK: - Values
    let imgHeight = 100
    
    // MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        guard let user = AppInfo.currentUser else { return }
        avatarView.setImage(string: user.displayName,
                            color: user.avatarColor,
                            circular: true,
                            stroke: true,
                            textAttributes: [.font: UIFont.systemFont(ofSize: 30),
                                             .foregroundColor: UIColor.white])
    }
    
    // MARK: Layouts
    func setUpViews() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(avatarView)
        contentView.addSubview(subTitleLabel)
    }
    
    func initData(title: String?, subTitle: String?) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        setUpConstraints()
    }
    
    func setUpConstraints() {
        avatarView.snp.makeConstraints {
           $0.top.equalToSuperview().offset(20)
           $0.centerX.equalToSuperview()
           $0.width.height.equalTo(imgHeight)
        }
        
        titleLabel.snp.makeConstraints {
           $0.centerX.equalToSuperview()
           $0.top.equalTo(avatarView.snp.bottom).offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
           $0.centerX.equalToSuperview()
           $0.top.equalTo(titleLabel.snp.bottom)
           $0.bottom.equalToSuperview().offset(-30)
        }
    }
}
