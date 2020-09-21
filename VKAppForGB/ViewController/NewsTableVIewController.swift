//
//  NewsTableVIewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 15.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class NewsTableVIewController: UITableViewController {
    
    lazy var newsArray: [News]? = [News]()
    var newsResponse: NewsResponse? = NewsResponse()
    var networkService = NetworkService.shared
    
    // MARK: TableVIewController LIfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        self.refreshControl?.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        
        loadNews() {
            self.newsArray = self.newsResponse!.items
        }
        
    }
    
    
    // MARK: TableView methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableVIewCell") as! NewsTableVIewCell
        
        guard let news = newsArray?[indexPath.row] else { return cell }
        
        let newsOwnerUser = Profiles()
        let newsOwnerGroup = Groups()
//        var newsPhotos: [Photo]
        
        var attachmentPhotoUrl: String = ""
        var newsOwnerPhotoUrl: String = ""
        
//        var newsLink: String
        
        guard let newsAttachmentsArray = news.attachments else { return cell }
        for attachment in newsAttachmentsArray {
            switch attachment.type {
            case "photo":
                for size in attachment.photo!.sizes! {
                    if size.type == "p" {
                        attachmentPhotoUrl = size.url!
                    }
                }
            case "post":
                print("post")
            default:
                print("other types")
            }
        }
        
        //newsImage
        guard let newsImageUrl = URL(string: attachmentPhotoUrl), let newsImageData = try? Data(contentsOf: newsImageUrl) else { return cell }
        
        //newsOwnerImage
        guard let newsOwnerUrl = URL(string: newsOwnerPhotoUrl), let newsOwnerImageData = try? Data(contentsOf: newsOwnerUrl) else { return cell }
        
        cell.newsImage?.image = UIImage(data: newsImageData)
        
        //cell.newsOwnerName.text & cell.newsOwnerImage.imageURL
        if news.sourceId! > 0 {
            cell.newsOwnerName.text = newsOwnerUser.firstName! + " " + newsOwnerUser.lastName!
//           newsOwnerPhotoUrl = ??
        } else {
            cell.newsOwnerName.text = newsOwnerGroup.name
            newsOwnerPhotoUrl = newsOwnerGroup.photo50!
        }
        
        cell.newsOwnerImage.image = UIImage(data: newsOwnerImageData)
        cell.newsText?.text = news.text
        
        cell.newsLikesLabel.text = String(describing: news.likes?.count)
        cell.newsRepostLabel.text = String(describing: news.reposts?.count)
        cell.newsCommentariesLabel.text = String(describing: news.comments?.count)
        cell.newsViewsLabel.text = String(describing: news.views?.count)
        
        
        return cell
    }
    
    // MARK: Request methods
    
    func loadNews(completion: (() -> Void)? = nil) {
        guard newsResponse != nil else { return }
        
        networkService.usersNewsRequest() { [weak self] newsResponse in
            DispatchQueue.main.async {
                
                self?.newsResponse = newsResponse
                
                completion?()
                
                self?.tableView.reloadData()
            }
        }
        
        
    }
    
    // MARK: Refresh table
    
    @objc func refreshTable(_ sender: Any?) {
        loadNews()
        print("refresh")
        refreshControl?.endRefreshing()
    }
    
    
}
 
