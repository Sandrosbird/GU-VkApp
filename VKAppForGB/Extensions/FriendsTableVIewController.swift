//
//  FriendsTableVIewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 02.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension MyFriendsTableViewController {
    
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
        
        guard let url = URL(string: urlForAvatar ), let data = try? Data(contentsOf: url) else { return cell }
        
        cell.friendName.text = "\(friend.firstName ) \(friend.lastName)"
        cell.friendIcon.image = UIImage(data: data)
        
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
}
