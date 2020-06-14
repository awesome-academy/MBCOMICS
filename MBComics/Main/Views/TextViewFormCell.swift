//
//  TextViewFormCell.swift
//  MBComics
//
//  Created by HoaPQ on 6/14/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Cosmos

class TextViewFormCell: BaseTBCell, FormCellType {
    private lazy var textView = UITextView().then {
        $0.font = .systemFont(ofSize: 14)
        $0.isScrollEnabled = false
        $0.delegate = self
    }
    
    private lazy var placeHolderLabel = UILabel().then {
        $0.text = "Write a Review"
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 14)
    }
    
    var onUpdateValue: ((String, Any?) -> Void)?
    var title = ""
    private var placeHolder = "" {
        didSet {
            placeHolderLabel.text = placeHolder
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        contentView.addSubview(placeHolderLabel)
        initLayout()
        separatorInset = UIEdgeInsets(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.textView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(kScreenHeight - 210)
        }
        self.placeHolderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(textView).offset(2)
            make.top.equalTo(textView).offset(8)
        }
    }
    
    func initData(title: String, placeHolder: String) {
        self.title = title
        self.placeHolder = placeHolder
    }
}

extension TextViewFormCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.placeHolderLabel.isHidden = !textView.text.isEmpty
        if let text = textView.text, !text.isEmpty {
            onUpdateValue?(title, text)
        } else {
            onUpdateValue?(title, nil)
        }
    }
}
