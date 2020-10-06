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
    
    @IBOutlet private var searchTextField: UISearchBar?
    
    var searchText: String { searchTextField?.text ?? "" }
    
    let realmService = RealmService.shared
    var realmToken: NotificationToken?
    
    lazy var photoCacheService = PhotoCacheService(container: self.tableView)
        
    var friendsArray: Results<User>? {
        let friends: Results<User>? = realmService?.getFromRealm()
        return friends
    }
    
    var searchedFriends: Results<User>? {
        guard !searchText.isEmpty else { return friendsArray }
        
        return friendsArray?.filter(NSPredicate(format: "firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", searchText, searchText))
    }
    
    private func loadFriends() {
        guard friendsArray != nil else { return }
        FriendsRequestAsyncOperation().friendsRequest() { [weak self] friends in
            DispatchQueue.main.async {
                try? self?.realmService?.addManyObjects(objects: friends)
                self?.tableView.reloadData()
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
            self.loadFriends()
            self.createRealmNotification()
        }
    }
    
    //MARK: DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchedFriends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
        
        guard let friend = searchedFriends?[indexPath.row] else { return cell }
        let urlForAvatar = friend.photo
        
        //        guard let url = URL(string: urlForAvatar ), let data = try? Data(contentsOf: url) else { return cell }
        
        cell.friendName.text = "\(friend.firstName ) \(friend.lastName)"
        cell.friendIcon.image = photoCacheService.photo(at: indexPath, url: urlForAvatar)
        
        return cell
    }
    
    // MARK: Метод для передачи id из нажатой ячейки
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let friend = searchedFriends?[indexPath.row] else { return nil }
        print(friend.id)
        ownerIdTransfer(friend: friend)
        return indexPath
    }
    
    private func ownerIdTransfer(friend: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(identifier: "FriendsPhotoCollectionViewController") as? FriendsPhotoCollectionViewController else { return }
        
        destinationViewController.ownerId = friend.id
        show(destinationViewController, sender: nil)
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

