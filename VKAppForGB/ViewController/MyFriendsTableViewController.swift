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
    
    let friendsRequestQueue = OperationQueue()
    
    var friendsArray: Results<User>? {
        let friends: Results<User>? = realmService?.getFromRealm()
        return friends
    }
    
    var searchedFriends: Results<User>? {
        guard !searchText.isEmpty else { return friendsArray }
        
        return friendsArray?.filter(NSPredicate(format: "firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", searchText, searchText))
    }
    
    
    private func loadFriends(completion: (() -> Void)? = nil) {
        guard friendsArray != nil else { return }
        
        NetworkService.shared.friendsRequest()
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

