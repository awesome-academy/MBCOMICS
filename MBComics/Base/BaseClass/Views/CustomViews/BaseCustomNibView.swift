//
//  BaseCustomNibView.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//

import Foundation
import UIKit
import SnapKit

class BaseCustomNibView: UIView {
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// Setup default value
    func commonInit() {
        let nibName = self.customNibName()
        let nib = UINib(nibName: nibName, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(contentView)
    }
    
    func customNibName() -> String {
        return String(describing: type(of: self))
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.contentView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
