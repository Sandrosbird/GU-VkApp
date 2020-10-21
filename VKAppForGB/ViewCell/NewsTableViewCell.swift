//
//  NewsTableViewCell.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 15.09.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

protocol NewsTableViewCellDelegate: class {
    func didTapShowMore(cell: NewsTableVIewCell)
}

class NewsTableVIewCell: UITableViewCell {
    
    weak var delegate: NewsTableViewCellDelegate?
    
    @IBOutlet weak var newsOwnerImage: UIImageView!
    @IBOutlet weak var newsOwnerName: UILabel!
    @IBOutlet weak var newsText: UILabel?
    @IBOutlet weak var newsImage: UIImageView?
    @IBOutlet weak var newsLikesLabel: UILabel!
    @IBOutlet weak var newsRepostLabel: UILabel!
    @IBOutlet weak var newsCommentariesLabel: UILabel!
    @IBOutlet weak var newsViewsLabel: UILabel!
    
    @IBOutlet weak var showMoreButton: UIButton?
    
    var isExpanded = false {
        didSet {
            updatePostLabel()
            updateShowMoreButton()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()

//        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        newsOwnerImage.layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    @objc private func showMoreTapped() {
        delegate?.didTapShowMore(cell: self)
    }
    
    private func updatePostLabel() {
        newsText?.numberOfLines = isExpanded ? 0 : 10
    }
    
    private func updateShowMoreButton() {
        let title = isExpanded ? "Show less." : "Show more..."
        showMoreButton?.setTitle(title, for: .normal)
    }
    
    private func setup() {
        selectionStyle = .none
        
        updatePostLabel()
        updateShowMoreButton()
        
        showMoreButton?.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
    }
}
