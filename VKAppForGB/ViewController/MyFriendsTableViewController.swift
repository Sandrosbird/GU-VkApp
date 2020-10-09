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
        
    var friendsArray: Results<User>? = {
        let friends: Results<User>? = RealmService.shared?.getFromRealm()
        return friends
    }()
    
    var searchedFriends: Results<User>? {
        guard !searchText.isEmpty else { return friendsArray }
        
        return friendsArray?.filter(NSPredicate(format: "firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", searchText, searchText))
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
}

