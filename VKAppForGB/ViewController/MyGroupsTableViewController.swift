//
//  MyGroupsTableViewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 29.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class MyGroupsTableViewController: UITableViewController {
    
    @IBAction func addGroup(seque: UIStoryboardSegue) {
        guard seque.identifier == "addGroup" else { return }
        let allGroupsController = seque.source as! AllGroupsTableViewController
        
        if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
            let group = allGroupsController.groupsArray[indexPath.row]
            
            if !groupsArray.contains(group){
                groupsArray.append(group)
                tableView.reloadData()
            }
        }
    }
    
    var groupsArray = [Group]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkService.shared.groupsRequest() { [weak self] groups in
            self?.groupsArray = groups
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsTableViewCell
        let group = groupsArray[indexPath.row]
        cell.groupImage.image = group.imagePhoto
        cell.groupName.text = group.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
