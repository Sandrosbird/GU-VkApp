//
//  CircleUIView.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 02.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class CircleUIView: UIView {
    
//    @IBInspectable
//    var shadowColor: UIColor = .black   {
//        didSet {
//            self.refreshShadowColor()
//        }
//    }
//    
//    @IBInspectable
//    var shadowOpacity: CGFloat = 1.0 {
//        didSet {
//            self.refreshShadowOpacity()
//        }
//    }
//    
//    @IBInspectable
//    var shadowRadius: CGFloat = 1.0 {
//        didSet {
//            self.refreshShadowRadius()
//        }
//    }
//    
//    @IBInspectable
//    var shadowOffset: CGSize = .zero {
//        didSet {
//            self.refreshShadowOffset()
//        }
//    }
//
//    
//    func refreshShadowColor() {
//        self.layer.shadowColor = self.shadowColor.cgColor
//    }
//    
//    func refreshShadowOpacity() {
//        self.layer.shadowOpacity = Float(self.shadowOpacity)
//    }
//    
//    func refreshShadowRadius() {
//        self.layer.shadowRadius = self.shadowRadius
//    }
//    
//    func refreshShadowOffset() {
//        self.layer.shadowOffset = shadowOffset
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height/2
            //bounds.height / 2
        
    }
}
    
    
    
