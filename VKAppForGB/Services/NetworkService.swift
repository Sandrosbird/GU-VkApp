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
    
    //MARK: OperationQueue
    
    let friendsQueue = OperationQueue()
    
    //MARK: Network methods
    
    func friendsRequest() {
        let operation = FriendsRequestAsyncOperation()
        operation.start()
    }
    
//    func friendsRequest(completion: @escaping ([User])  -> Void ) {
//            let session = NetworkService.shared.session
//            var usersArray = [User]()
//
//            var urlConstructor = URLComponents()
//            urlConstructor.scheme = self.schemeHttps
//            urlConstructor.host = self.hostVk
//            urlConstructor.path = "/method/friends.get"
//            urlConstructor.queryItems = [
//                URLQueryItem(name: "user_id", value: "\(Session.current.userId)"),
//                URLQueryItem(name: "access_token", value: Session.current.token),
//                URLQueryItem(name: "v", value: "5.122"),
//                URLQueryItem(name: "count", value: "200"), //количество возвращаемых друзей
//                URLQueryItem(name: "fields", value: "photo_50")
//            ]
//
//            let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
//
//                do{
//                    let jsonResponse = try JSONDecoder().decode(MainResponse.self, from: data!)
//
//                    usersArray = jsonResponse.response.items
//
//                    //                print(usersArray)
//                } catch {
//                    print(error.localizedDescription)
//                }
//                completion(usersArray)
//            }
//            task.resume()
//    }
    
    func groupsRequest(completion: @escaping ([Group]) -> Void) {
        
        let parseDispatchGroup = DispatchGroup()
        
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
            DispatchQueue.global().async(group: parseDispatchGroup) {
                do{
                    let jsonResponse = try JSONDecoder().decode(MainGroupsResponse.self, from: data!).response
                    groupsArray = jsonResponse.items
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            parseDispatchGroup.notify(queue: DispatchQueue.main) {
                completion(groupsArray)
            }
        }
        task.resume()
    }

    func personsPhotoRequest(ownerId: Int, completion: @escaping ([UserPhotos]) -> Void) {
        
        let parseDispatchGroup = DispatchGroup()
        
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
            DispatchQueue.global().async(group: parseDispatchGroup) {
                do {
                    let jsonResponse = try JSONDecoder().decode(MainUserPhotosResponse.self, from: data!).response
                    
                    photos = jsonResponse.items
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            parseDispatchGroup.notify(queue: DispatchQueue.main) {
                completion(photos)
            }
            
        }
        task.resume()
    }
    
    func usersNewsRequest(completion: @escaping (NewsResponse) -> Void) {
        let session = NetworkService.shared.session
        
        var news = NewsResponse()
        var newsResponse = [News]()
        var groupsResponse = [Groups]()
        var profilesResponse = [Profiles]()
        
        let parseDispatchGroup = DispatchGroup()

        var urlConstructor = URLComponents()
        urlConstructor.scheme = schemeHttps
        urlConstructor.host = hostVk
        urlConstructor.path = "/method/newsfeed.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "v", value: "5.124"),
            URLQueryItem(name: "fields", value: "id"),
            URLQueryItem(name: "fields", value: "first_name"),
            URLQueryItem(name: "fields", value: "last_name"),
            URLQueryItem(name: "fields", value: "name"),
//            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "filters", value: "post")

        ]

        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            DispatchQueue.global().async(group: parseDispatchGroup) {
                do {
                    newsResponse = try JSONDecoder().decode(MainNewsResponse.self, from: data!).response?.items ?? [News]()
                } catch {
                    print(error)
                }
            }
            
            DispatchQueue.global().async(group: parseDispatchGroup) {
                do {
                    groupsResponse = try JSONDecoder().decode(MainNewsResponse.self, from: data!).response?.groups ?? [Groups]()
                } catch {
                    print(error)
                }
            }
            
            DispatchQueue.global().async(group: parseDispatchGroup) {
                do {
                    profilesResponse = try JSONDecoder().decode(MainNewsResponse.self, from: data!).response?.profiles ?? [Profiles]()
                } catch {
                    print(error)
                }
            }
            
            parseDispatchGroup.notify(queue: DispatchQueue.main) {
                news = NewsResponse(items: newsResponse, profiles: profilesResponse, groups: groupsResponse)
                completion(news)
            }
        }
        task.resume()
    }
}

