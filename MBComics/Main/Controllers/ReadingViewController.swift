//
//  ReadingViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class ReadingViewController: UIViewController {

    // MARK: - Outlets
    
    // MARK: - Values
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: - Layouts
    func setUpViews() {
        title = "Reading comic"
        view.backgroundColor = .white
    }
    
    func setUpConstraints() {
        
    }
}
