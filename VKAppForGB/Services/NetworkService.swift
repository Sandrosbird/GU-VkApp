//
//  NetworkService.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 13.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import WebKit

class NetworkService {
    
    private lazy var session: URLSession = {
          let configuration = URLSessionConfiguration.default
          configuration.allowsCellularAccess = false
          let session = URLSession(configuration: configuration)
          return session
      }()
    
    static let shared = NetworkService()
    
    private init() {}
    
    func friendsRequest() -> [User]{
        
        let session = NetworkService.shared.session
        var usersArray = [User]()
                      
        var urlConstructor = URLComponents()
                urlConstructor.scheme = "https"
                urlConstructor.host = "api.vk.com"
                urlConstructor.path = "/method/friends.get"
                urlConstructor.queryItems = [
                    URLQueryItem(name: "user_id", value: "\(Session.current.userId)"),
                    URLQueryItem(name: "access_token", value: Session.current.token),
                    URLQueryItem(name: "v", value: "5.92"),
                    URLQueryItem(name: "count", value: "10"), //количество возвращаемых друзей
                    URLQueryItem(name: "fields", value: "photo_50")
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            
//            print(Session.current.token, Session.current.userId)
            
            let receivedJson = json as! [String:Any]
            let response = receivedJson["response"] as! [String:Any]
            let count = response["count"] as! Int
            let itemsArray = response["items"] as! [Any]
            for item in itemsArray {
                let item = item as! [String:Any]
                
                let user = User(json: item)
//                let id = item["id"] as! Int
//                let firstName = item["first_name"] as! String
//                let lastName = item["last_name"] as! String
//                let photo = item["photo_50"] as! String
///                let isClosed = item["is_closed"] as! Bool
///                let canAccessClosed = item["can_access_closed"] as! Bool
///                let online = item["onlne"] as! Int
//
                usersArray.append(user)
                print(user)
            }
            
            
        }
        task.resume()
        return usersArray
    }
    
    func groupsRequest() {
        let session = NetworkService.shared.session
                      
        var urlConstructor = URLComponents()
                urlConstructor.scheme = "https"
                urlConstructor.host = "api.vk.com"
                urlConstructor.path = "/method/groups.get"
                urlConstructor.queryItems = [
                    URLQueryItem(name: "user_id", value: "\(Session.current.userId)"),
                    URLQueryItem(name: "access_token", value: Session.current.token),
                    URLQueryItem(name: "v", value: "5.92"),
                    URLQueryItem(name: "extended", value: "1"),
                    URLQueryItem(name: "count", value: "10")
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
        }
        task.resume()
    }
    
    func personsPhotoRequest() {
        let session = NetworkService.shared.session
                      
        var urlConstructor = URLComponents()
                urlConstructor.scheme = "https"
                urlConstructor.host = "api.vk.com"
                urlConstructor.path = "/method/photos.get"
                urlConstructor.queryItems = [
                    URLQueryItem(name: "user_id", value: "\(Session.current.userId)"),
                    URLQueryItem(name: "access_token", value: Session.current.token),
                    URLQueryItem(name: "v", value: "5.92"),
                    URLQueryItem(name: "album_id", value: "profile"),
                    URLQueryItem(name: "owner_id", value: "\(Session.current.userId)"),
                    URLQueryItem(name: "count", value: "10")
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
        }
        task.resume()
    }
    
  
    
    
    
}

