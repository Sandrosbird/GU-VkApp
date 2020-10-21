//
//  UserPhotosModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 20.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

struct MainUserPhotosResponse: Decodable {
    let response: UserPhotosResponse
}

struct UserPhotosResponse: Decodable {
    var count: Int = 0
    var items: [UserPhotos]
}

class UserPhotos: Object, Decodable {
    
    @objc dynamic var photoId = 0
    @objc dynamic var ownerId = 0
    //    @objc dynamic var sizes: [String : String] = [:]
    var sizes = List<PhotoSizes>()
    
    override class func primaryKey() -> String? {
        return "photoId"
    }
    
    enum CodingKeys: String, CodingKey {
        case sizes
        case photoId = "id"
        case ownerId = "owner_id"
    }
}


class PhotoSizes: Object, Decodable {
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case height, width, type, url
    }

    override class func primaryKey() -> String? {
        return "url"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.height = try response.decode(Int.self, forKey: .height)
        self.width = try response.decode(Int.self, forKey: .width)
        self.type = try response.decode(String.self, forKey: .type)
        self.url = try response.decode(String.self, forKey: .url)
    }
    
}
