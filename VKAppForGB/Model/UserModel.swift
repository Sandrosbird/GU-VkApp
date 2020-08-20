//
//  UserModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 17.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct MainResponse: Decodable {
    let response: FriendsResponse
}

struct FriendsResponse: Decodable {
    var count: Int = 0
    var items: [User]
}

class User: Decodable {
    dynamic var id: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
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
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_50"
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



//struct User {
//    let id: Int
//    var firstName = ""
//    var lastName = ""
//    var photo = ""
//
//    init(id: Int) {
//        self.id = id
//    }
//
//    init(json: [String:Any]) {
//        let id = json["id"] as! Int
//        self.init(id: id)
//
//        self.firstName = json["first_name"] as! String
//        self.lastName = json["last_name"] as! String
//        self.photo = json["photo_50"] as! String
//    }
//
//
//
//}
