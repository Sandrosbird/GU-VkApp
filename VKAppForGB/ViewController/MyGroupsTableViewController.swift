//
//  MyGroupsTableViewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 29.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsTableViewController: UITableViewController {
    
    @IBOutlet private var searchTextField: UISearchBar?

    let realmService = RealmService.shared
    var realmToken: NotificationToken?
    lazy var photoCacheService = PhotoCacheService(container: self.tableView)
    
    private var searchText: String { searchTextField?.text ?? "" }
    
    var groupsArray: Results<Group>? {
        let groups: Results<Group>? = realmService?.getFromRealm()
        return groups
    }
    
    var searchedGroups: Results<Group>? {
        guard !searchText.isEmpty else { return groupsArray! }
        return groupsArray?.filter(NSPredicate(format: "name CONTAINS[cd] %@", searchText))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        self.refreshControl?.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        
        if let groupsArray = groupsArray, groupsArray.isEmpty {
            loadGroups()
        }
    }
}

