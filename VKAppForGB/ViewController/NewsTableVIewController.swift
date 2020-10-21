//
//  NewsTableVIewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 15.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit


class NewsTableVIewController: UITableViewController, UITableViewDataSourcePrefetching, NewsTableViewCellDelegate {
    
    var newsResponse = NewsResponse()
    var newsArray: [News]?
    var profilesArray: [Profiles]?
    var groupsArray: [Groups]?
    var networkService = NetworkService.shared
    let noPhotoUrl = "https://vk.com/images/camera_50.png"
    
    var isLoading = false
    var nextNewsItem = ""
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyy"
        return dateFormatter
    }()

    // MARK: TableVIewController LIfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        setupTableView()

        loadNews() { [weak self] in
            self?.newsArray = self?.newsResponse.items
            self?.profilesArray = self?.newsResponse.profiles
            self?.groupsArray = self?.newsResponse.groups
            self?.nextNewsItem = self?.newsResponse.nextFrom ?? ""
        }
    }
    
    private func configureRefreshControl() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        self.refreshControl?.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
    }
    
    private func setupTableView() {
        tableView.prefetchDataSource = self
    }
    
    //MARK: UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print(#function)
        guard
            let maxRow = indexPaths.map({ $0.row }).max(),
            maxRow > (newsArray?.count ?? 0) - 3,
            isLoading == false
        else { return }
        
        isLoading = true
        networkService.usersNewsRequest(fromItem: nextNewsItem) { [weak self] (newsResponse) in
            guard let strongSelf = self else { return }
            
            guard
                let fetchedNews = newsResponse.items,
                let newsCount = strongSelf.newsArray?.count
            else { return }
            
            
            strongSelf.newsArray?.append(contentsOf: fetchedNews)
            let indexPaths =
                (newsCount..<(newsCount + fetchedNews.count))
                .map { IndexPath(row: $0, section: 0) }
            strongSelf.tableView.insertRows(at: indexPaths, with: .automatic)
            strongSelf.isLoading = false
        }   
    }
    
    //MARK: NewsTableViewCellDelegate
    func didTapShowMore(cell: NewsTableVIewCell) {
        tableView.beginUpdates()
        cell.isExpanded.toggle()
        tableView.endUpdates()
    }
}



 
