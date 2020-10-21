//
//  UITableViewExtension+EmptyMessage.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 16.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension UITableView {
    
    func showEmptyMessage(message: String) {
        let label = UILabel(frame: bounds)
        label.text = message
        label.textColor = .gray
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        
        self.backgroundView = label
    }
    
    func hideEmptyMessage() {
        self.backgroundView = nil
    }
    
}
