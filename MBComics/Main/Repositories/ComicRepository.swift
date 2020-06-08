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
}

struct ComicRepository: ComicRepositoryType {
    let api: APIService
    
    func getHomeComics(completion: @escaping (ErrorResponse?, [HomeComic], [HomeComic]) -> Void) {
        api.request(urlString: AppUrl.homeUrl,
                    httpMethod: .get,
                    header: nil,
                    param: nil,
                    body: nil) { (status, error, json) in
            if let json = json {
                let popularComics = json["popular"].arrayValue.map { HomeComic($0) }
                let newestComics = json["newest"].arrayValue.map { HomeComic($0) }
                
                completion(nil, popularComics, newestComics)
            } else {
                completion(error, [], [])
            }
        }
    }
}
