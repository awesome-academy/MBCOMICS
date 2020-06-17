//
//  ReadingViewController.swift
//  MBComics
//
//  Created by HoaPQ on 6/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import ImageSlideshow
import FontAwesome_swift

class ReadingViewController: UIViewController {

    // MARK: - Outlets
    private lazy var slideshow = ImageSlideshow().then {
        $0.pageIndicator = LabelPageIndicator()
        $0.zoomEnabled = true
        $0.circular = false
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tap))
        singleTap.numberOfTapsRequired = 1
        $0.addGestureRecognizer(singleTap)

        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        $0.addGestureRecognizer(doubleTap)

        singleTap.require(toFail: doubleTap)
    }

    // MARK: - Values
    private let comicRepository = ComicRepository(api: APIService.shared)
    
    private var isBarHidden = false
    private var issueId = ""
    private var issueDetail: DetailIssue?

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstraints()
    }
    
    func initData(issueId: String) {
        self.issueId = issueId
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getData()
    }

    // MARK: - Layouts
    private func setUpViews() {
        title = "Reading comic"
        view.backgroundColor = .white

        view.addSubview(slideshow)
        slideshow.isHidden = true
    }

    private func setUpConstraints() {
        slideshow.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.margins)
        }
    }

    // MARK: - Actions
    private func getData() {
        showPopupLoading()
        comicRepository.getIssueDetail(of: issueId) { [weak self] (error, issue) in
            DispatchQueue.main.async {
                self?.hidePopupLoading()
                self?.handleIssueApi(error: error, issue: issue)
            }
        }
    }
    
    private func handleIssueApi(error: ErrorResponse?, issue: DetailIssue?) {
        slideshow.isHidden = false
        if let error = error {
            showAlert(title: error.name, message: error.message)
            slideshow.setImageInputs([ImageSource(image: kErrorPlaceHolderImage)])
        } else {
            issueDetail = issue
            guard let imageUrls = issueDetail?.images else { return }
            slideshow.setImageInputs(imageUrls.map {
                guard let url = $0.url else { return ImageSource(image: kErrorPlaceHolderImage) }
                return KingfisherSource(url: url,
                                        options: [.requestModifier(kKfModifier)])
            })
        }
    }

    @objc private func tap() {
        if issueDetail != nil {
            isBarHidden = !isBarHidden
            navigationController?.setNavigationBarHidden(isBarHidden, animated: true)
        } else {
            getData()
        }
    }
}
