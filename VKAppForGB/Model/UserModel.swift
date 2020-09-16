//
//  UserModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 17.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

struct MainResponse: Decodable {
    let response: FriendsResponse
}

struct FriendsResponse: Decodable {
    var count: Int = 0
    var items: [User]
}

class User: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photo = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_50"
    }
    
    //уникальный ключ для модели в базе Realm
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init (from decoder: Decoder) throws {
        self.init()
        
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try response.decode(Int.self, forKey: .id)
        self.firstName = try response.decode(String.self, forKey: .firstName)
        self.lastName = try response.decode(String.self, forKey: .lastName)
        self.photo = try response.decode(String.self, forKey: .photo)
       
    }
}
