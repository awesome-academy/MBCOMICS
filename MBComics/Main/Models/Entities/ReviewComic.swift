//
//  ReviewComic.swift
//  MBComics
//
//  Created by HoaPQ on 5/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

struct ReviewComic {
    var reviewId: String
    var comicId: Int
    var user: UserInfo
    var content: String
    var reviewScore: Int
    var reviewAt: Date

    init?(_ snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        
        guard let _comicId = dict["comic_id"] as? Int,
              let _userId = dict["user_id"] as? String,
              let _userDisplayName = dict["user_name"] as? String,
              let _content = dict["content"] as? String,
              let _reviewScore = dict["score"] as? Int,
              let _dateString = dict["review_at"] as? String,
              let _reviewAt = _dateString.toFirebaseDate()
        else { return nil }
        
        reviewId = snapshot.key
        comicId = _comicId
        user = UserInfo(uid: _userId, displayName: _userDisplayName)
        content = _content
        reviewScore = _reviewScore
        reviewAt = _reviewAt
    }
}

extension ReviewComic: DatabaseRepresentable {
    var representation: [String : Any] {
        return ["review_id": reviewId,
                "comic_id": comicId,
                "user_id": user.uid,
                "user_name": user.displayName,
                "content": content,
                "score": reviewScore,
                "review_at": reviewAt.toFirebaseDateString()]
    }
}
