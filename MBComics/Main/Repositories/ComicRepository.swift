//
//  ComicRepository.swift
//  MBComics
//
//  Created by HoaPQ on 6/8/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

protocol ComicRepositoryType {
    func getHomeComics(completion: @escaping (ErrorResponse?, [HomeComic], [HomeComic]) -> Void)
    func getDetailComic(comicId: Int, completion: @escaping (ErrorResponse?, DetailComic?) -> Void)
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
                    body: nil) { (status, error, json) in
            if let json = json {
                let detailComic = DetailComic(json)
                completion(nil, detailComic)
            } else {
                completion(error, nil)
            }
        }
    }
}
