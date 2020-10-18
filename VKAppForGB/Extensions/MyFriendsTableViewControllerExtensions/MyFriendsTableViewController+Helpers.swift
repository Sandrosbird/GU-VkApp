//
//  MyFriendsTableViewController+Helpers.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 09.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

extension MyFriendsTableViewController {
    //MARK: Helpers
    
    func loadFriends() {
        guard friendsArray != nil else { return }
        FriendsRequestAsyncOperation().friendsRequest() { [weak self] friends in
            DispatchQueue.main.async {
                try? self?.realmService?.addManyObjects(objects: friends)
                self?.tableView.reloadData()
            }
        }
    }
    
    func createRealmNotification() {
        
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
    
    @objc func refreshTable(_ sender: Any?) {
          loadFriends()
          print("refresh")
          refreshControl?.endRefreshing()
      }
    
}
