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
    
    
    private let realmService = RealmService.shared
    
    var groupsArray: Results<Group>? {
        let groups: Results<Group>? = realmService?.getFromRealm()
        return groups
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let groupsArray = groupsArray, groupsArray.isEmpty {
            loadGroups()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsTableViewCell
        
        let group = groupsArray?[indexPath.row]
        let groupAvatarURL = group?.photo
        
        guard let url = URL(string: groupAvatarURL ?? ""), let data = try? Data(contentsOf: url) else { return cell }
        
        cell.groupImage.image = UIImage(data: data)
        cell.groupName.text = group?.name
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .
//            groupsArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
}
