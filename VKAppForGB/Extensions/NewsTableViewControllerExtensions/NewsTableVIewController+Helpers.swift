//
//  NewsTableVIewController+Helpers.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 09.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension NewsTableVIewController {
    
    // MARK: Request methods
    func loadNews(completion: (() -> Void)? = nil) {
        
        NetworkService.shared.usersNewsRequest() { [weak self] newsResponse in
            DispatchQueue.main.async(qos: .userInitiated) {
                self?.newsResponse = newsResponse
                completion?()
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: Refresh table
    @objc func refreshTable(_ sender: Any?) {
        loadNews()
        tableView.reloadData()
        print("refresh")
        refreshControl?.endRefreshing()
    }
    
}
