//
//  UserModel.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 29.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

struct User {
    let name: String
    let age: Int
    let gender: String
    let avatar: UIImage
    let userPhotos: [UIImage]
    
}

final class FriendsFactory {
    static func generateFriends() -> [User] {
        let sharon = User(name: "Шерон Маккой", age: 23, gender: "female", avatar: UIImage(named: "female1")!, userPhotos: [UIImage(named: "female1")!, UIImage(named: "female2")!, UIImage(named: "male3")!])
        let rosamond = User(name: "Розамонд Тайлер", age: 33, gender: "female", avatar: UIImage(named: "female1")!, userPhotos: [UIImage(named: "female1")!, UIImage(named: "female2")!, UIImage(named: "male3")!])
        let george = User(name: "Джордж Пирсон", age: 17, gender: "male", avatar: UIImage(named: "male3")!, userPhotos: [UIImage(named: "female1")!, UIImage(named: "male3")!, UIImage(named: "male2")!])
        let christopher = User(name: "Кристофер Тодд", age: 22, gender: "male", avatar: UIImage(named: "male3")!, userPhotos: [UIImage(named: "female1")!, UIImage(named: "male3")!, UIImage(named: "male2")!])
        let theodore = User(name: "Теодор Лайонс", age: 29, gender: "male", avatar: UIImage(named: "male2")!, userPhotos: [UIImage(named: "male3")!, UIImage(named: "male2")!, UIImage(named: "female2")!])
        let alan = User(name: "Алан Харт", age: 24, gender: "male", avatar: UIImage(named: "male2")!, userPhotos: [UIImage(named: "male3")!, UIImage(named: "male2")!, UIImage(named: "female2")!])
        let rebecca = User(name: "Ребекка Уиллис", age: 42, gender: "female", avatar: UIImage(named: "female2")!, userPhotos: [UIImage(named: "male2")!, UIImage(named: "female2")!, UIImage(named: "male3")!])
        let lora = User(name: "Лора Стивенс", age: 21, gender: "female", avatar: UIImage(named: "female2")!, userPhotos: [UIImage(named: "male2")!, UIImage(named: "female2")!, UIImage(named: "male3")!])
        
        return [sharon, rosamond, george, christopher, theodore, alan, rebecca, lora]
    }
    
    static func inAlphabetOrder(usersArray: [User]) -> [User] {
        let sortedFriends = usersArray.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        return sortedFriends
    }
}
