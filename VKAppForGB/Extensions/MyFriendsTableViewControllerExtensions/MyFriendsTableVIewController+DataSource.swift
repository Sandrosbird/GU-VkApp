//
//  FriendsTableVIewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 02.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension MyFriendsTableViewController {
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
}
