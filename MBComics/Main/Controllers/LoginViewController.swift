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
    private lazy var logoImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "ic_app")
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var backgroundView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "background")
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var blurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .light)
        $0.alpha = 0.9
    }
    
    private lazy var facebookButton = FBLoginButton().then {
        if let facebookButtonHeightConstraint = $0.constraints.first(where: { $0.firstAttribute == .height }) {
            $0.removeConstraint(facebookButtonHeightConstraint)
        }
    }
    
    private lazy var googleButton = GIDSignInButton().then {
        $0.style = .wide
    }
    
    // MARK: - Values
    private let userRepository = UserRepository(api: APIService.shared)

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: - Layouts
    private func setUpViews() {
        self.navigationController?.isNavigationBarHidden = true
        
        view.do {
            $0.addSubview(backgroundView)
            $0.addSubview(logoImageView)
            $0.addSubview(facebookButton)
            $0.addSubview(googleButton)
        }
        
        backgroundView.addSubview(blurView)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        facebookButton.delegate = self
    }
    
    private func setUpConstraints() {
        backgroundView.snp.makeConstraints {
           $0.edges.equalToSuperview()
        }
        
        blurView.snp.makeConstraints {
           $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
           $0.width.equalTo(logoImageView.snp.height)
           $0.centerX.equalToSuperview()
            let width = min(view.width*0.3, 150)
           $0.width.equalTo(width)
           $0.centerY.equalToSuperview().offset(-view.height/4)
        }
        logoImageView.applyCornerRadius(radius: 24)
        
        googleButton.snp.makeConstraints {
           $0.centerY.equalToSuperview().offset(view.height/8)
           $0.centerX.equalToSuperview()
           $0.bottom.equalTo(facebookButton.snp.top).offset(-16)
        }
        
        facebookButton.snp.makeConstraints {
           $0.width.height.equalTo(googleButton).inset(3)
           $0.centerX.equalToSuperview()
        }
    }
}

extension LoginViewController: GIDSignInDelegate, LoginButtonDelegate {
    func handleLoginResult(_ error: Error?) {
        hidePopupLoading()
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
        } else {
            userRepository.setUpCurrentUser()
            showAlert(title: "Success", message: "Login Successful.") {
                Application.shared.changeRootViewController?()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        showPopupLoading()
        userRepository.login(with: credential) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.handleLoginResult(error)
            }
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        guard let accessToken = AccessToken.current else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        showPopupLoading()
        userRepository.login(with: credential) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.handleLoginResult(error)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}
