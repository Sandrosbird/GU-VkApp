//
//  GroupsModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 20.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct MainGroupsResponse: Decodable {
    let response: GroupsResponse
}

struct GroupsResponse: Decodable {
    var count: Int = 0
    var items: [Group]
}

class Group: Codable, Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return true
    }
    
    var id: Int = 0
    dynamic var name: String = ""
    dynamic var photo: String = ""
    dynamic var imagePhoto: UIImage {
        var image = UIImage()
        
        let imageURl = URL(string: photo)!
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURl) else { return }
            let receivedImage = UIImage(data: imageData)
            guard receivedImage != nil else { return }
            image = receivedImage!
        }
        
        print("Аватар получен")
        
        return image
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case photo = "photo_50"
    }
    
}
