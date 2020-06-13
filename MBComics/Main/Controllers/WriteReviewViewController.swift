//
//  WriteReviewViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController {

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
        view.backgroundColor = .white
        title = "Write Review"
        
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = item
        view.backgroundColor = .white
    }
    
    func setUpConstraints() {
        
    }
}
