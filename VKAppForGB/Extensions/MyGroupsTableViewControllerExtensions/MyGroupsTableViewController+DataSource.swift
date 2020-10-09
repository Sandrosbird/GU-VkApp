//
//  MyGroupsTableViewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 06.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension MyGroupsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsTableViewCell
        
        let group = searchedGroups?[indexPath.row]
        let groupAvatarURL = group?.photo
        
//        guard let url = URL(string: groupAvatarURL ?? ""), let data = try? Data(contentsOf: url) else { return cell }
        
        cell.groupImage.image = photoCacheService.photo(at: indexPath, url: groupAvatarURL)
        cell.groupName.text = group?.name
        
        return cell
    }
}
