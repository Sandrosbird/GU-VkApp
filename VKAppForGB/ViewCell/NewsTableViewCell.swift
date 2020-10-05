//
//  NewsTableViewCell.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 15.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class NewsTableVIewCell: UITableViewCell {
    
    @IBOutlet weak var newsOwnerImage: UIImageView!
    @IBOutlet weak var newsOwnerName: UILabel!
    @IBOutlet weak var newsText: UILabel?
    @IBOutlet weak var newsImage: UIImageView?
    @IBOutlet weak var newsLikesLabel: UILabel!
    @IBOutlet weak var newsRepostLabel: UILabel!
    @IBOutlet weak var newsCommentariesLabel: UILabel!
    @IBOutlet weak var newsViewsLabel: UILabel!
    
    override func layoutSubviews() {
        newsOwnerImage.layer.cornerRadius = 20
        clipsToBounds = true
    }
}
