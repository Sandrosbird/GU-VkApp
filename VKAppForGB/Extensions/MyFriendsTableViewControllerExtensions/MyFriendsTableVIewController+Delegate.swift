//
//  MyFriendsTableVIewController+Delegate.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 09.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension MyFriendsTableViewController {
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
}

extension MyFriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}
