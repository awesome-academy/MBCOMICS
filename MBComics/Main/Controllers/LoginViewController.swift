//
//  LoginViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/1/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import Then

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    lazy var logoImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "ic_app")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var backgroundView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "background")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var blurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .light)
        $0.alpha = 0.9
    }
    
    lazy var facebookButton = FBLoginButton().then {
        if let facebookButtonHeightConstraint = $0.constraints.first(where: { $0.firstAttribute == .height }) {
            $0.removeConstraint(facebookButtonHeightConstraint)
        }
    }
    
    lazy var googleButton = GIDSignInButton().then {
        $0.style = .wide
    }
    
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
        view.do {
            $0.addSubview(backgroundView)
            $0.addSubview(logoImageView)
            $0.addSubview(facebookButton)
            $0.addSubview(googleButton)
        }
        
        backgroundView.addSubview(blurView)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func setUpConstraints() {
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(logoImageView.snp.height)
            make.centerX.equalToSuperview()
            let width = min(view.width*0.3, 150)
            make.width.equalTo(width)
            make.centerY.equalToSuperview().offset(-view.height/4)
        }
        logoImageView.applyCornerRadius(radius: 24)
        
        googleButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(view.height/8)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(facebookButton.snp.top).offset(-16)
        }
        
        facebookButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(googleButton).inset(3)
            make.centerX.equalToSuperview()
        }
    }
    
}
