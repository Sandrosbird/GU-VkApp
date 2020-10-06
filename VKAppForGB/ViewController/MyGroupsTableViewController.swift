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

    private let realmService = RealmService.shared
    private var realmToken: NotificationToken?
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
    
    private func loadGroups() {
        guard groupsArray != nil else { return }
        NetworkService.shared.groupsRequest() { [weak self] groups in
            DispatchQueue.main.async {
                try? self?.realmService?.addManyObjects(objects: groups)
                self?.tableView.reloadData()
            }
        }
    }
    
    private func createRealmNotification() {
        
        realmToken = groupsArray?.observe { (changes: RealmCollectionChange) in
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
        
        if let groupsArray = groupsArray, groupsArray.isEmpty {
            loadGroups()
        }
    }
    
    @objc func refreshTable(_ sender: Any?) {
        loadGroups()
        print("refresh")
        refreshControl?.endRefreshing()
    }    
}

extension MyGroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}
