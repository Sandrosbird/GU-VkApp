//
//  MyGroupsTableViewController+Helpers.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 09.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

extension MyGroupsTableViewController {
    
    func loadGroups() {
        guard groupsArray != nil else { return }
        NetworkService.shared.groupsRequest() { [weak self] groups in
            DispatchQueue.main.async {
                try? self?.realmService?.addManyObjects(objects: groups)
                self?.tableView.reloadData()
            }
        }
    }
    
    func createRealmNotification() {
        
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
    
    @objc func refreshTable(_ sender: Any?) {
        loadGroups()
        print("refresh")
        refreshControl?.endRefreshing()
    } 
    
}
