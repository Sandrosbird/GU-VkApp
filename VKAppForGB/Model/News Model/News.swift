//
//  News.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 18.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct News: Decodable {
    let sourceId, date, markedAsAds, postId: Int?
    let canDoubtCategory, canSetCategory, isFavorite: Bool?
    let postType, text, type: String?
    let attachments: [Attachments]?
//    let postSource: PostSource?
    let comments: Comments?
    let likes: Likes?
    let reposts: Reposts?
    let views: Views?
    
    enum CodingKeys: String, CodingKey {
        case text, date, attachments, comments, likes, reposts, views, type
        case sourceId = "source_id"
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case postType = "post_type"
        case markedAsAds = "marked_as_ads"
//        case postSource = "post_source"
        case isFavorite = "is_favorite"
        case postId = "post_id"
    }
}

struct PostSource: Decodable{
    let type: String?
}

struct Attachments: Decodable {
    let type: String?
    let photo: Photo?
    let link: Link?
}

struct Photo: Decodable {
    let albumId, date, id, ownerId, userId: Int?
    let hasTags: Bool?
    let accessKey, text: String?
    let sizes: [Sizes]?
    
    enum CodingKeys: String, CodingKey {
        case date, id, sizes, text
        case albumId = "album_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case userId = "user_id"
        case ownerId = "owner_id"
    }
}

struct Sizes: Decodable {
    let height, width: Int?
    let type, url: String?
    
    enum CodingKeys: String, CodingKey {
        case height, url, type, width
    }
}

struct Link: Decodable {
    let url, title, description, target, text: String?
    let photo: Photo?
    let isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case url, title, description, target, text, photo
        case isFavorite = "is_favorite"
    }
}

