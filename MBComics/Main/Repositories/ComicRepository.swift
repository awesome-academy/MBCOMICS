//
//  ComicRepository.swift
//  MBComics
//
//  Created by HoaPQ on 6/8/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ComicRepositoryType {
    func getHomeComics(completion: @escaping (ErrorResponse?, [HomeComic], [HomeComic]) -> Void)
    func getDetailComic(comicId: Int, completion: @escaping (ErrorResponse?, DetailComic?) -> Void)
    func getReviews(of comicId: Int, completion: @escaping (Error?, [ReviewComic]) -> Void)
    func writeReview(for comicId: Int, content: String, ratePoint: Int, user: UserInfo, completion: @escaping (Error?) -> Void)
    func searchByName(of query: String, completion: @escaping (ErrorResponse?, [SearchComic]) -> Void)
    func getIssueDetail(of issueId: String, completion: @escaping (ErrorResponse?, DetailIssue?) -> Void)
}

struct ComicRepository: ComicRepositoryType {
    let api: APIService
    
    func getHomeComics(completion: @escaping (ErrorResponse?, [HomeComic], [HomeComic]) -> Void) {
        let input = HomeRequest()
        api.request(input: input) { (error, json) in
            if let json = json {
                let popularComics = json["popular"].arrayValue.map { HomeComic($0) }
                let newestComics = json["newest"].arrayValue.map { HomeComic($0) }
                
                completion(nil, popularComics, newestComics)
            } else {
                completion(error, [], [])
            }
        }
    }
    
    func getInfoTBData(comic: DetailComic) -> [LineInfoComic] {
        let infoTBData = [LineInfoComic]().with {
            $0.append(LineInfoComic(title: ComicInfo.author,
                                    detail: (comic.authors.sentence)))
            $0.append(LineInfoComic(title: ComicInfo.category,
                                    detail: (comic.genres.sentence)))
            $0.append(LineInfoComic(title: ComicInfo.publisher,
                                    detail: (comic.publisher)))
            $0.append(LineInfoComic(title: ComicInfo.year,
                                    detail: (comic.year)))
            $0.append(LineInfoComic(title: ComicInfo.status,
                                    detail: (comic.status.stringValue)))
            $0.append(LineInfoComic(title: ComicInfo.numberIssues,
                                    detail: "\((comic.numberIssues) - 1)"))
            $0.append(LineInfoComic(title: ComicInfo.contactUs,
                                    detail: ComicInfo.email))
        }
        
        return infoTBData
    }
    
    func getDetailComic(comicId: Int, completion: @escaping (ErrorResponse?, DetailComic?) -> Void) {
        let input = DetailRequest(comicId: comicId)
        api.request(input: input) { (error, json) in
            if let json = json {
                let detailComic = DetailComic(json)
                completion(nil, detailComic)
            } else {
                completion(error, nil)
            }
        }
    }
    
    func getReviews(of comicId: Int, completion: @escaping (Error?, [ReviewComic]) -> Void) {
        let ref = Database.database().reference().child("Reviews")

        ref.queryOrdered(byChild: "comic_id").queryEqual(toValue: comicId)
           .observeSingleEvent(of: .value) { snapshot in
                var reviews = [ReviewComic]()
                snapshot.children.forEach {
                    guard let snap = $0 as? DataSnapshot,
                          let review = ReviewComic(snap) else { return }
                    reviews.append(review)
                }
                completion(nil, reviews)
        }
    }
    
    func getReviewInfo(of comicId: Int, completion: @escaping (ComicRateInfo?) -> Void) {
        let ref = Database.database().reference().child("Comics")
        ref.child("\(comicId)").observeSingleEvent(of: .value) { (snapshot) in
            completion(ComicRateInfo(snapshot))
        }
    }
    
    func getReviewInfo(of comics: [Comic], completion: @escaping ([Comic]) -> Void) {
        let group = DispatchGroup()
        var results = [Comic]()
        comics.forEach {
            var comic = $0
            group.enter()
            getReviewInfo(of: comic.id) { (info) in
                if let info = info {
                    comic.ratingInfo = info
                }
                results.append(comic)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
    
    private func updateReviews(of comicId: Int) {
        let ref = Database.database().reference().child("Reviews")
        let refRate = Database.database().reference().child("Comics")

        ref.queryOrdered(byChild: "comic_id").queryEqual(toValue: comicId)
           .observeSingleEvent(of: .value) { snapshot in
                var reviews = [ReviewComic]()
                snapshot.children.forEach {
                    guard let snap = $0 as? DataSnapshot,
                          let review = ReviewComic(snap) else { return }
                    reviews.append(review)
                }
                let ratePoint = reviews.isEmpty ? 0.0 : Double(reviews.reduce(0, { $0 + $1.ratePoint })) / Double(reviews.count)
            let info = ComicRateInfo(comicId,
                                     ratePoint,
                                     reviews.count)
            refRate.child("\(comicId)").updateChildValues(info.representation)
        }
    }
    
    func writeReview(for comicId: Int, content: String, ratePoint: Int, user: UserInfo, completion: @escaping (Error?) -> Void) {
        let review = ReviewComic(comicId: comicId,
                                 content: content,
                                 ratePoint: ratePoint,
                                 user: user)
        let ref = Database.database().reference(withPath: "Reviews")
        ref.child(review.reviewId).updateChildValues(review.representation) { (error, _) in
            self.updateReviews(of: comicId)
            completion(error)
        }
    }
    
    func searchByName(of query: String, completion: @escaping (ErrorResponse?, [SearchComic]) -> Void) {
        let input = SearchRequest(query: query)
        api.request(input: input) { (error, json) in
            if let json = json {
                let comics = json.arrayValue.map { SearchComic($0) }
                completion(nil, comics)
            } else {
                completion(error, [])
            }
        }
    }
    
    func getIssueDetail(of issueId: String, completion: @escaping (ErrorResponse?, DetailIssue?) -> Void) {
        let input = IssueRequest(issueId: issueId)
        api.request(input: input) { (error, json) in
            if let json = json {
                let issue = DetailIssue(json)
                completion(nil, issue)
            } else {
                completion(error, nil)
            }
        }
    }
}
