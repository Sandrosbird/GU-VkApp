//
//  Main+UserResponse.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 18.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct MainNewsResponse: Decodable {
    let response: NewsResponse?
}

struct NewsResponse: Decodable {
    var items: [News]? = []
    var profiles: [Profiles]? = []
    var groups: [Groups]? = []
    var nextFrom: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}




