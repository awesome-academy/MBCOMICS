//
//  ComicDetailViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class ComicDetailViewController: UIViewController {
    // MARK: - Outlets
    
    // MARK: - Values
    var comicId = 0

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
    }
    
    func setData(comicId: Int) {
        self.comicId = comicId
    }
    
    // MARK: - Layouts
    func setUpViews() {
        view.backgroundColor = .white
        title = "Comic Detail"
    }
}
