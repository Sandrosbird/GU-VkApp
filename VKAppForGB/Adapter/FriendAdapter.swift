//
//  FriendAdapter.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 13.11.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

final class FriendAdapter {
    private let networkService = NetworkService.shared
    private var realmNotificationToken: [String: NotificationToken] = [:]
    
    func getFriends(id: Int, completion: @escaping ([User]) -> Void) {
        let stringId = String(id)
        guard let realm = try? Realm(),
              let realmFriend = realm.object(ofType: User.self, forPrimaryKey: id)
        else { return }

        realmNotificationToken[stringId]?.invalidate()
        
        let token = realmFriend.observe { [weak self] change in
            switch change {
            case .change(_,_):
                print("")
            case .deleted:
                print("")
            case .error(let error):
                print(error)
            }
        }
    }

    private func returnFriends(from user: User) -> AdaptedUser {
        return AdaptedUser(id: user.id, firstName: user.firstName, lastName: user.lastName, photo: user.photo)
    }
}
