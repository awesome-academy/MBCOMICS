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
        
        guard let comicId = dict["comic_id"] as? Int,
              let userId = dict["user_id"] as? String,
              let userDisplayName = dict["user_name"] as? String,
              let content = dict["content"] as? String,
              let reviewScore = dict["score"] as? Int,
              let dateString = dict["review_at"] as? String,
              let reviewAt = dateString.toFirebaseDate()
        else { return nil }
        
        reviewId = snapshot.key
        user = UserInfo(uid: userId, displayName: userDisplayName)
        
        self.comicId = comicId
        self.content = content
        self.reviewScore = reviewScore
        self.reviewAt = reviewAt
    }
}

extension ReviewComic: DatabaseRepresentable {
    var representation: [String: Any] {
        return ["review_id": reviewId,
                "comic_id": comicId,
                "user_id": user.uid,
                "user_name": user.displayName,
                "content": content,
                "score": reviewScore,
                "review_at": reviewAt.toFirebaseDateString()]
    }
}
