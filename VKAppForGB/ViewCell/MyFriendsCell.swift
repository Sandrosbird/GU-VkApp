//
//  MyFriendsCell.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 29.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class MyFriendsCell: UITableViewCell {
    @IBOutlet weak var friendIcon: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func layoutSubviews() {
        friendIcon.layer.cornerRadius = bounds.height/2
        clipsToBounds = true
    }
}
