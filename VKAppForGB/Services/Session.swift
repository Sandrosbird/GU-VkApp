//
//  Session.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 09.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class Session {
    
    static let current = Session()
    
    private init() {}
    
    var token = String()
    var userId = Int()
    
    var userIdForPhotoSegue = Int()
}
