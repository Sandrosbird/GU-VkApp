//
//  MyFriendsController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 29.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class MyFriendsTableViewController: UITableViewController {
    
    var friendsArray: [User] = NetworkService.shared.friendsRequest()
    var sortedFriends: [User] {
        get {
            return MyFriendsTableViewController.inAlphabetOrder(usersArray: friendsArray)
        }
        set { }
    }
    var sectionNames: [String] {
        get {
            var firstWordsArray = [String]()
            for friend in sortedFriends {
                if !firstWordsArray.contains(String(friend.firstName.first!)) {
                    firstWordsArray.append(String(friend.firstName.first!))
                }
            }
            
            let sortedFirstWordsArray = firstWordsArray.sorted(by: { $0.lowercased() < $1.lowercased() })
            return sortedFirstWordsArray
        }
        set { }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NetworkService.shared.friendsRequest()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionNames
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames.remove(at: section)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let indexPath = IndexPath.init()
//        var numberOfRowsInSection = Int()
//
//        if  sectionNames[indexPath.row].contains(friendsArray[indexPath.row].name.first!) {
//            numberOfRowsInSection += 1
//        }
//
//        return numberOfRowsInSection
        return sortedFriends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
        let currentSectionName = sectionNames[indexPath.section]
        let firstLetterOfName = String(sortedFriends[indexPath.row].firstName.first!)
        if  firstLetterOfName == currentSectionName {
            let friend = sortedFriends[indexPath.row]
//            cell.friendIcon.image = friend.photo
            cell.friendName.text = friend.firstName+" "+friend.lastName
        }
        
        return cell
    }
    
}

extension MyFriendsTableViewController {
    static func inAlphabetOrder(usersArray: [User]) -> [User] {
        let sortedFriends = usersArray.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        return sortedFriends
    }
}
