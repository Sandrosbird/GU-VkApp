//
//  AsyncImageView.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 19.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

class AsyncImageView: UIImageView {
    
    private var _image: UIImage?
    
    override var image: UIImage? {
        get {
            return _image
        }
        set {
            _image = newValue
            
            layer.contents = nil
            
            guard let image = newValue else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let decodedImage = self.decode(image)
                DispatchQueue.main.async {
                    self.layer.contents = decodedImage
                }
            }
            
        }
    }
    
    private func decode(_ image: UIImage ) -> CGImage? {
        guard let newImage = image.cgImage else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: nil,
            width: newImage.width,
            height: newImage.height,
            bitsPerComponent: 8,
            bytesPerRow: newImage.width * 8,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )
        
        let contextRect = CGRect(x: 0, y: 0, width: newImage.width, height: newImage.width)
        context?.draw(newImage, in: contextRect)
        
        return context?.makeImage()
    }
    
}
