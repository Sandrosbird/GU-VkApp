//
//  ProfilesNewsResponse.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 18.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct Profiles: Decodable {
    var id: Int? = 0
    var firstName: String? = ""
    var lastName: String? = ""
    var deactivated: String? = ""
    var isClosed: Bool? = true
    var canAccessClosed: Bool? = true
    
    
    enum CodingKeys: String, CodingKey {
        case id, deactivated
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
    }
}

struct Groups: Decodable {
    var id: Int? = 0
    var isClosed: Int? = 0
    var isAdmin: Int? = 0
    var isMember: Int? = 0
    var isAdvertiser: Int? = 0
    var name: String? = ""
    var screenName: String? = ""
    var type: String? = ""
    var photo50: String? = ""
    var photo100: String? = ""
    var photo200: String? = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, type
        case isClosed = "is_closed"
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}
