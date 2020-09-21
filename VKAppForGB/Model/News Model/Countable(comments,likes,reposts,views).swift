//
//  Countable(comments,likes,reposts,views).swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 18.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct Comments: Decodable {
    let count: Int?
    let canPost: Int?
    let groupsCanPost: Bool?
    
    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}

struct Likes: Decodable {
    let count, userLikes, canLike, canPublish: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
    
}

struct Reposts: Decodable {
    let count, wallCount, mailCount, userReposted: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case wallCount = "wall_count"
        case mailCount = "mail_count"
        case userReposted = "user_reposted"
    }
}

struct Views: Decodable {
    let count: Int?
}

//"comments": {
//    "count": 0,
//    "can_post": 0,
//    "groups_can_post": true
//},
//"likes": {
//    "count": 646,
//    "user_likes": 0,
//    "can_like": 1,
//    "can_publish": 1
//},
//"reposts": {
//    "count": 5,
//    "wall_count": 0,
//    "mail_count": 0,
//    "user_reposted": 0
//},
//"views": {
//    "count": 12949
//},
