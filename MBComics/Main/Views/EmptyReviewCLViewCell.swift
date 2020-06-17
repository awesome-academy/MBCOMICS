//
//  EmptyReviewCLViewCell.swift
//  ComicLife(project2.3)
//
//  Created by Macintosh on 6/10/19.
//  Copyright © 2019 Macintosh. All rights reserved.
//

import UIKit

class EmptyReviewCLViewCell: BaseCLCell {
    
    // MARK: - Outlets
    var descriptionLabel = UILabel().then {
        $0.text = "No Review"
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 10
        backgroundColor = .groupTableViewBackground
        contentView.addSubview(descriptionLabel)
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - Layouts
    func initLayout() {
        self.descriptionLabel.snp.makeConstraints {
           $0.centerX.centerY.equalToSuperview()
        }
    }
}
