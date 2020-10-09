//
//  NewsTableVIewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 15.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit


class NewsTableVIewController: UITableViewController {
    
    var newsResponse = NewsResponse()
    var newsArray: [News]?
    var profilesArray: [Profiles]?
    var groupsArray: [Groups]?
    var networkService = NetworkService.shared
    let noPhotoUrl = "https://vk.com/images/camera_50.png"

    // MARK: TableVIewController LIfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        self.refreshControl?.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        
        loadNews() { [weak self] in
            self?.newsArray = self?.newsResponse.items
            self?.profilesArray = self?.newsResponse.profiles
            self?.groupsArray = self?.newsResponse.groups
        }
    }
}



 
