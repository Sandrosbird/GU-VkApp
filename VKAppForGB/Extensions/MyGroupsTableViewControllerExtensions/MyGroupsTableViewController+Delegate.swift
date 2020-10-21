//
//  MyGroupsTableViewController+Delegate.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 09.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension MyGroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}
