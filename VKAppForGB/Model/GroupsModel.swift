//
//  GroupsModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 20.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

struct MainGroupsResponse: Decodable {
    let response: GroupsResponse
}

struct GroupsResponse: Decodable {
    var count: Int = 0
    var items: [Group]
}

class Group: Object, Codable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return true
    }
    
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case photo = "photo_50"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try response.decode(Int.self, forKey: .id)
        self.name = try response.decode(String.self, forKey: .name)
        self.photo = try response.decode(String.self, forKey: .photo)
     }
    
}
