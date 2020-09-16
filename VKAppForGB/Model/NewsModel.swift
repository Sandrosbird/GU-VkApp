//
//  NewsModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 16.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

struct MainUserNewsResponse: Decodable {
    let response: UserNewsResponse
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct UserNewsResponse: Decodable {
    var items: [News]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct News: Decodable {
    var sourceId = 0
    var date = 0
    var attachments: [NewsAttachments]
    var comments: NewsCountableItems
    var likes: NewsCountableItems
    var reposts: NewsCountableItems
    var views: NewsCountableItems
    
    enum CodingKeys: String, CodingKey {
        case sourceId, date, attachments, comments, likes, reposts, views
    }
}

struct NewsAttachments: Decodable {
    var type: String
    var photo: [UserPhotos]
    
    enum CodingKeys: String, CodingKey {
        case type, photo
    }
}

struct NewsCountableItems: Decodable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}

