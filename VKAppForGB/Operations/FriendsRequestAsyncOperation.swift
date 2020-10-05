//
//  FriendsRequestAsyncOperation.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 05.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class FriendsRequestAsyncOperation: AsyncOperation {
    
    private let schemeHttps = "https"
    private let hostVk = "api.vk.com"
    private let realmService = RealmService.shared
    
    
    //сессия для запросов
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    override func main() {
        friendsRequest() { [weak self] friends in
            try? self?.realmService?.addManyObjects(objects: friends)
        }
    }
    
    func friendsRequest(completion: @escaping ([User])  -> Void ) {
        let session = FriendsRequestAsyncOperation().session
        var usersArray = [User]()
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = self.schemeHttps
        urlConstructor.host = self.hostVk
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: "\(Session.current.userId)"),
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "v", value: "5.122"),
            URLQueryItem(name: "count", value: "200"), //количество возвращаемых друзей
            URLQueryItem(name: "fields", value: "photo_50")
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            do{
                let jsonResponse = try JSONDecoder().decode(MainResponse.self, from: data!)
                
                usersArray = jsonResponse.response.items
                
                //                print(usersArray)
            } catch {
                print(error.localizedDescription)
            }
            completion(usersArray)
        }
        task.resume()
    }
}
