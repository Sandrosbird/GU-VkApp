//
//  UserPhotosModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 20.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct MainUserPhotosResponse: Decodable {
    let response: UserPhotosResponse
}

struct UserPhotosResponse: Decodable {
    var count: Int = 0
    var items: [UserPhotos]
}


class UserPhotos: Decodable {
    
    var photoId = 0
    var ownerId = 0
    var sizes: [String : String] = [:]
    
    enum CodingKeys: String, CodingKey {
        case sizes
        case photoId = "id"
        case ownerId = "owner_id"
    }
    
    enum PhotoSizes: String, CodingKey {
        case height, width, type, url
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.photoId = try response.decode(Int.self, forKey: .photoId)
        self.ownerId = try response.decode(Int.self, forKey: .ownerId)
        
        var photoSizes = try response.nestedUnkeyedContainer(forKey: .sizes)
        
        while !photoSizes.isAtEnd {
            let photo = try photoSizes.nestedContainer(keyedBy: PhotoSizes.self)
            let photoType = try photo.decode(String.self, forKey: .type)
            let photoUrl = try photo.decode(String.self, forKey: .url)
            
            sizes[photoType] = photoUrl
            
        }
        
        
    }
 
}

//class PhotoSizes: Decodable {
//    var height: Int = 0
//    var width: Int = 0
//    var type: String = ""
//    var url: String = ""
//    
//    enum CodingKeys: String, CodingKey {
//        case height, width, type, url
//    }
//    
//    required convenience init(from decoder: Decoder) throws {
//        self.init()
//        
//        let response = try decoder.container(keyedBy: CodingKeys.self)
//        self.height = try response.decode(Int.self, forKey: .height)
//        self.width = try response.decode(Int.self, forKey: .width)
//        self.type = try response.decode(String.self, forKey: .type)
//        self.url = try response.decode(String.self, forKey: .url)
//    }
//    
//}
