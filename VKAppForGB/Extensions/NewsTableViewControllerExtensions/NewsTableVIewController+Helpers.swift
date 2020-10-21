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
            DispatchQueue.global().async(qos: .userInitiated) {
                self?.newsResponse = newsResponse
                completion?()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }   
            }
        }
    }
    
    // MARK: Refresh table
    @objc func refreshTable(_ sender: Any?) {
        let mostFreshIntTime = (newsArray?.first?.date) ?? 0
        let mostFreshTime = Date(timeIntervalSince1970: TimeInterval(mostFreshIntTime)).timeIntervalSince1970
        
        networkService.usersNewsRequest(from: mostFreshTime+1) { [weak self] (freshNewsResponse) in
            self?.refreshControl?.endRefreshing()
            
            guard
                let strongSelf = self,
                let newsArray = strongSelf.newsArray,
                let freshNews = freshNewsResponse.items,
                freshNews.count > 0
            else { return }
            
            strongSelf.newsArray = freshNews + newsArray
            
            let indexPaths = (0..<freshNews.count).map { IndexPath(row: $0, section: 0) }
            
            strongSelf.tableView.insertRows(at: indexPaths, with: .automatic)
        }
        print("refresh")
    }
}
