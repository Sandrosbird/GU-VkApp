//
//  MyFriendsController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 29.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

class MyFriendsTableViewController: UITableViewController {

    @IBOutlet var searchTextField: UISearchBar?
    var searchText: String { searchTextField?.text ?? "" }
    
//    private var searchedFriends: Results<User>? {
//        guard !searchText.isEmpty else { return friendsArray! }
//
////        return friendsArray?.filter(NSPredicate(format: "firstName CONTAINS[cd] %@", searchText))
//        return friendsArray?.filter({ (friend) -> Bool in
//            friend.firstName.contains(searchText)
//        })
//    }
    
    private let realmService = RealmService.shared
    
    var friendsArray: Results<User>? {
        let friends: Results<User>? = realmService?.getFromRealm()
        return friends
    }
    
    
    //make set from friends array
//    lazy var sortedFriends = User.inAlphabetOrder(users: friendsArray)
    
        
//
//    var sectionNames: [String] {
//        get {
//            sortedFriends.keys
//        }
//        set { }
//    }
    
    private func loadFriends(completion: (() -> Void)? = nil) {
        guard friendsArray != nil else { return }
            NetworkService.shared.friendsRequest() { [weak self] friends in
                DispatchQueue.main.async {
                    try? self?.realmService?.addManyObjects(objects: friends)
                    self?.tableView.reloadData()
                    print("данные из сети")
                    completion? ()
                }
            }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friendsArray = friendsArray, friendsArray.isEmpty {
            loadFriends()
        }
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
        
        return friendsArray?.count ?? 0
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
              
        let friend = friendsArray?[indexPath.row]
        let urlForAvatar = friend?.photo
        
        guard let url = URL(string: urlForAvatar ?? ""), let data = try? Data(contentsOf: url) else { return cell }
        
        cell.friendName.text = "\(friend?.firstName ?? "NO")  \(friend?.lastName ?? "Name")"
        cell.friendIcon.image = UIImage(data: data)

        
        return cell
    }
    
    
}

extension MyFriendsTableViewController {
    static func inAlphabetOrder(usersArray: [User]) -> [User] {
        let sortedFriends = usersArray.sorted(by: { $0.firstName.lowercased() < $1.firstName.lowercased() })
        return sortedFriends
    }
}
