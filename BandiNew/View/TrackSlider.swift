//
//  TrackSlider.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/6/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class TrackSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        minimumTrackTintColor = Constants.Colors().primaryColor
        maximumTrackTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        let image = UIImage(named: "videosliderthumb")
        let size = CGSize(width: 10, height: 10)
        setThumbImage(imageWithImage(image: image!, scaledToSize: size), for: .normal)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 6
        return newBounds
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
