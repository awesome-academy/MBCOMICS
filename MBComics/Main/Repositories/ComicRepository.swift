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
}

struct ComicRepository: ComicRepositoryType {
    let api: APIService
    
    func getHomeComics(completion: @escaping (ErrorResponse?, [HomeComic], [HomeComic]) -> Void) {
        api.request(urlString: AppUrl.homeUrl,
                    httpMethod: .get,
                    header: nil,
                    param: nil,
                    body: nil) { (_, error, json) in
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
        api.request(urlString: AppUrl.comicUrl,
                    httpMethod: .get,
                    header: nil,
                    param: ["id": comicId],
                    body: nil) { (_, error, json) in
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
    
    func writeReview(for comicId: Int, content: String, ratePoint: Int, user: UserInfo, completion: @escaping (Error?) -> Void) {
        let review = ReviewComic(comicId: comicId,
                                 content: content,
                                 ratePoint: ratePoint,
                                 user: user)
        let ref = Database.database().reference(withPath: "Reviews")
        ref.child(review.reviewId).updateChildValues(review.representation) { (error, _) in
            completion(error)
        }
    }
}
