//
//  BaseTBCell.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class BaseTBCell: UITableViewCell {
    
    // MARK: define for cell
    static func identifier() -> String {
        return String(describing: self.self)
    }
    
    static func height() -> CGFloat {
        return 0
    }
    
    static func registerCellByClass(_ tableView: UITableView) {
        tableView.register(self.self, forCellReuseIdentifier: self.identifier())
    }
    
    static func registerCellByNib(_ tableView: UITableView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.identifier())
    }
    
    static func loadCell(_ tableView: UITableView) -> BaseTBCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: self.identifier()) as? BaseTBCell) else {
            return BaseTBCell()
        }
        return cell
    }
    
    static func loadCell(_ tableView: UITableView, indexPath: IndexPath) -> BaseTBCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: self.identifier(), for: indexPath) as? BaseTBCell) else {
            return BaseTBCell()
        }
        return cell
    }
}

extension BaseTBCell {
    func initData(title: String?, detail: String?) {
        textLabel?.text = title
        detailTextLabel?.text = detail
    }
}
