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
        setThumbImage(UIImage.imageWithImage(image: image!, scaledToSize: size), for: .normal)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 6
        return newBounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
