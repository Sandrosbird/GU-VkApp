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
    
    
    private let realmService = RealmService.shared
    private var realmToken: NotificationToken?
    
    
    var friendsArray: Results<User>? {
        let friends: Results<User>? = realmService?.getFromRealm()
        return friends
    }
    
    private var searchedFriends: Results<User>? {
        guard !searchText.isEmpty else { return friendsArray! }
        
        return friendsArray?.filter(NSPredicate(format: "firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", searchText, searchText))
    }
    
    private func loadFriends(completion: (() -> Void)? = nil) {
        guard friendsArray != nil else { return }
        NetworkService.shared.friendsRequest() { [weak self] friends in
            DispatchQueue.main.async {
                try? self?.realmService?.addManyObjects(objects: friends)
                self?.tableView.reloadData()
                //                    print("данные из сети")
                completion? ()
            }
        }
    }
    
    private func createRealmNotification() {
        
        realmToken = friendsArray?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                
                self.tableView.reloadData()
                
            case let .update(_, deletions: deletions, insertions: insertions, modifications: modifications):
                
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .right)
                self.tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .left)
                self.tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .fade)
                self.tableView.endUpdates()
                
            case .error(let error):
                
                print(error)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        self.refreshControl?.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        
        if let friendsArray = friendsArray, friendsArray.isEmpty {
            loadFriends()
            createRealmNotification()
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
        
        return searchedFriends?.count ?? 0
        
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
        
        let friend = searchedFriends?[indexPath.row]
        let urlForAvatar = friend?.photo
        
        guard let url = URL(string: urlForAvatar ?? ""), let data = try? Data(contentsOf: url) else { return cell }
        
        cell.friendName.text = "\(friend?.firstName ?? "NO")  \(friend?.lastName ?? "Name")"
        cell.friendIcon.image = UIImage(data: data)
        
        
        return cell
    }
    
    @objc func refreshTable(_ sender: Any?) {
        loadFriends()
        print("refresh")
        refreshControl?.endRefreshing()
    }
    
    
}

extension MyFriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}
