//
//  UserModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 17.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct User {
    let id: Int
    var firstName = ""
    var lastName = ""
    var photo = ""
    
    init(id: Int) {
        self.id = id
    }
    
    init(json: [String:Any]) {
        let id = json["id"] as! Int
        self.init(id: id)
        
        self.firstName = json["first_name"] as! String
        self.lastName = json["last_name"] as! String
        self.photo = json["photo_50"] as! String
    }
    
    
    
}
