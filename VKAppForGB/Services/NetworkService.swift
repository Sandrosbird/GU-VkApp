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
    
    //свойства для работы с сетью
    private let schemeHttps = "https"
    private let hostVk = "api.vk.com"
    
    //сессия для запросов
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    static let shared = NetworkService()
    
    private init() {}
    

    // методы для работы с сетью
    func friendsRequest(completion: @escaping ([User])  -> Void ) {
        
        let session = NetworkService.shared.session
        var usersArray = [User]()
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = schemeHttps
        urlConstructor.host = hostVk
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
                print(error)
            }
            completion(usersArray)
        }
        
        task.resume()
        
    }

    
    
    func groupsRequest(completion: @escaping ([Group]) -> Void) {
        let session = NetworkService.shared.session
        
        var groupsArray = [Group]()

        var urlConstructor = URLComponents()
        urlConstructor.scheme = schemeHttps
        urlConstructor.host = hostVk
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: "\(Session.current.userId)"),
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "v", value: "5.92"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "150")
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            do{
                let jsonResponse = try JSONDecoder().decode(MainGroupsResponse.self, from: data!)
                
                groupsArray = jsonResponse.response.items
                
//                print(groupsArray)
            } catch {
                print(error)
            }
            completion(groupsArray)
        }
        
        task.resume()
    }

    func personsPhotoRequest(ownerId: Int, completion: @escaping ([UserPhotos]) -> Void) {
        let session = NetworkService.shared.session
        
        var photos = [UserPhotos]()
//        var photoUrl = [PhotoSizes]()

        var urlConstructor = URLComponents()
        urlConstructor.scheme = schemeHttps
        urlConstructor.host = hostVk
        urlConstructor.path = "/method/photos.getAll"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "v", value: "5.92"),
            URLQueryItem(name: "owner_id", value: "\(ownerId)")
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            do {
                let jsonResponse = try JSONDecoder().decode(MainUserPhotosResponse.self, from: data!)
                
                photos = jsonResponse.response.items
            } catch {
                print(error.localizedDescription)
            }
            completion(photos)
            

        }
        task.resume()
    }
    
    
    
    
    
}

