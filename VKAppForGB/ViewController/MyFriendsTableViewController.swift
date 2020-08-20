//
//  MyFriendsController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 29.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class MyFriendsTableViewController: UITableViewController {

//    lazy var friendsArray = [User]()
    var friendsArray = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
//    lazy var sortedFriends: [User] = {
//        MyFriendsTableViewController.inAlphabetOrder(usersArray: friendsArray)
//    }()
//    var sectionNames: [String] {
//        get {
//            var firstWordsArray = [String]()
//            for friend in sortedFriends {
//                if !firstWordsArray.contains(String(friend.firstName.first!)) {
//                    firstWordsArray.append(String(friend.firstName.first!))
//                }
//            }
//
//            let sortedFirstWordsArray = firstWordsArray.sorted(by: { $0.lowercased() < $1.lowercased() })
//            return sortedFirstWordsArray
//        }
//        set { }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkService.shared.friendsRequest() { [weak self] friends in
            self?.friendsArray = friends
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
//        return sectionNames.count
    }
//
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return sectionNames
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionNames.remove(at: section)
//    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let indexPath = IndexPath.init()
//        var numberOfRowsInSection = Int()
//
//        if  sectionNames[indexPath.row].contains(friendsArray[indexPath.row].name.first!) {
//            numberOfRowsInSection += 1
//        }
//
//        return numberOfRowsInSection
//        friendsArray = NetworkService.shared.friendsRequest()
        
        return friendsArray.count
//            sortedFriends.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
//        let currentSectionName = sectionNames[indexPath.section]
//        let firstLetterOfName = String(sortedFriends[indexPath.row].firstName.first!)
//        if  firstLetterOfName == currentSectionName {
//            let friend = sortedFriends[indexPath.row]
////            cell.friendIcon.image = friend.photo
//            cell.friendName.text = friend.firstName+" "+friend.lastName
//        }
              
        let friend = friendsArray[indexPath.row]
        let urlForAvatar = friend.photo
        
        
        
        cell.friendName.text = friend.firstName+" "+friend.lastName
        cell.friendIcon.image = friend.imagePhoto
        return cell
    }
    
}

extension MyFriendsTableViewController {
    static func inAlphabetOrder(usersArray: [User]) -> [User] {
        let sortedFriends = usersArray.sorted(by: { $0.firstName.lowercased() < $1.firstName.lowercased() })
        return sortedFriends
    }
}
