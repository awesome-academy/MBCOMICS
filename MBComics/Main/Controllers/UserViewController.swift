//
//  UserViewController.swift
//  MBComics
//
//  Created by HoaPQ on 5/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserViewController: BaseViewController {
    
    // MARK: - Outlets
    lazy var tableView = UITableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.delegate = self
        $0.dataSource = self
        UserInfoTBViewCell.registerCellByClass($0)
        HomeTBViewCell.registerCellByClass($0)
        $0.separatorStyle = .none
        $0.tableFooterView = UIView(frame: .zero)
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false
    }
    
    lazy var logOutLabel = UILabel().then {
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.text = "Log out"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.backgroundColor = .lightGray
        $0.textColor = .white
    }
    
    // MARK: - Values
    private let userRepository = UserRepository(api: APIService.shared)
    
    private let favoriteIndexPath = IndexPath(item: UserCellIndex.favoriteIndex.rawValue,
                                              section: 0)
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadRows(at: [favoriteIndexPath], with: .automatic)
    }
    
    // MARK: - Layouts
    func setUpViews() {
        isNavigationBarHidden = true
        view.backgroundColor = .white
        title = "User"
        
        view.addSubview(tableView)
        view.addSubview(logOutLabel)
        
        logOutLabel.addTapGesture(target: self, action: #selector(signOut))
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        
        logOutLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-20)
            make.height.equalTo(55)
        }
    }
    
    // MARK: - Actions
    @objc func signOut() {
        showAlertConfirm(title: "Sign Out",
                         message: "Good bye! Are you sure want to sign out?",
                         confirmHandler: { [weak self] in
                            self?.onSignOutConfirm()
        })
    }
    
    func onSignOutConfirm() {
        showPopupLoading()
        userRepository.signOut { [weak self] (error) in
            DispatchQueue.main.async {
                self?.hidePopupLoading()
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    let loginVC = LoginViewController()
                    self?.tabBarController?.navigationController?.changeRootViewController(loginVC)
                }
            }
        }
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserCellIndex.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch UserCellIndex(rawValue: indexPath.row) ?? .userInfoIndex {
        case .userInfoIndex:
            guard let cell = UserInfoTBViewCell.loadCell(tableView) as? UserInfoTBViewCell
                  else { return BaseTBCell() }
            
            cell.initData(title: Auth.auth().currentUser?.displayName, subTitle: Auth.auth().currentUser?.email)
            return cell
            
        case .favoriteIndex:
            guard let cell = HomeTBViewCell.loadCell(tableView) as? HomeTBViewCell,
                  let user = AppInfo.currentUser else { return BaseTBCell() }
            
            cell.initData(imgHeight: kCLCellHeight, title: "Favorite Comics", comics: user.favoriteComics)
            cell.delegate = self
            
            return cell
        }
    }
}

extension UserViewController: HomeTBCellDelegate {
    func pushVCToComic(comicId: Int) {
        let detailVC = ComicDetailViewController()
        detailVC.setData(comicId: comicId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func pushVCToAllComic(title: String?, comics: [Comic]) {
        let allComicsVC = AllComicViewController()
        allComicsVC.initData(title: title, comics: comics)
        navigationController?.pushViewController(allComicsVC, animated: true)
    }
    
    func tapFavoriteComic(comicId: Int, state: Bool) {
        guard let user = AppInfo.currentUser,
              let comic = user.favoriteComics.first(where: { $0.id == comicId })
              else { return }
        if state {
            userRepository.addFavoriteComic(comic: comic)
        } else {
            userRepository.removeFavoriteComic(comic: comic)
        }
    }
}
