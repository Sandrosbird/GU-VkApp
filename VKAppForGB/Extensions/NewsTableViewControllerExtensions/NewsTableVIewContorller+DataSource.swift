//
//  NewsTableVIewContorller.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 25.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension NewsTableVIewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (newsArray?.isEmpty ?? true) {
            tableView.showEmptyMessage(message: "Нет новостей")
        } else {
            tableView.hideEmptyMessage()
        }
        return newsArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableVIewCell") as! NewsTableVIewCell
        cell.delegate = self
        
        guard let news = newsArray?[indexPath.row] else { return cell }
        
        var newsOwnerUser = Profiles()
        var newsOwnerGroup = Groups()
        var newsOwnerName = "NoName"
        var newsText = "NoText"
        //        var newsPhotos: [Photo]
        
        var attachmentPhotoUrl: [String] = [""]
        var newsOwnerPhotoUrl: String = ""
        
        guard let newsAttachments = news.attachments else { return cell }
        
        // MARK: Cell for ProfilePost
        
        if news.sourceId ?? 0 > 0 {
            for profile in profilesArray ?? [Profiles]() {
                if news.sourceId == profile.id {
                    newsOwnerUser = profile
                }
            }
            
            newsOwnerName = newsOwnerUser.firstName! + " " + newsOwnerUser.lastName!
            newsOwnerPhotoUrl = newsOwnerUser.photo50 ?? noPhotoUrl
        
            guard let newsImageUrl = URL(string:  attachmentPhotoUrl[0]), let newsImageData = try? Data(contentsOf: newsImageUrl) else { return cell }
            
            cell.newsImage?.image = UIImage(data: newsImageData)
            
            // MARK: Cell for GroupPost
        } else {
            for group in groupsArray ?? [Groups]() {
                if -news.sourceId! == group.id {
                    newsOwnerGroup = group
                }
                
                newsOwnerName = newsOwnerGroup.name!
                newsOwnerPhotoUrl = newsOwnerGroup.photo50!
            }
        }
        
        guard let attachmentsSizes = newsAttachments[0].photo?.sizes else { return cell }
        for size in attachmentsSizes {
            if size.type == "x" {
                attachmentPhotoUrl.append(size.url ?? noPhotoUrl)
            }
        }
        
        guard let newsImageUrl = URL(string:  attachmentPhotoUrl[1]), let newsImageData = try? Data(contentsOf: newsImageUrl) else { return cell }
        
        cell.newsImage?.image = UIImage(data: newsImageData)
        
        newsText = news.text!
        guard let url = URL(string:  newsOwnerPhotoUrl), let data = try? Data(contentsOf: url) else { return cell }
        
        cell.newsOwnerImage.image = UIImage(data: data)
        cell.newsOwnerName.text = newsOwnerName
        
        cell.newsText?.text = newsText
        //        cell.newsImage?.image = UIImage(data: newsImageData)
        
        cell.newsLikesLabel.text = String(news.likes?.count ?? 0101)
        cell.newsRepostLabel.text = String(news.reposts?.count ?? 0101)
        cell.newsCommentariesLabel.text = String(news.comments?.count ?? 0101)
        cell.newsViewsLabel.text = String(news.views?.count ?? 0101)
        return cell
    }
}
