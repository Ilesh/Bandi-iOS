//
//  VolumeSlider.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/4/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import MediaPlayer

class VolumeSlider: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    lazy var volumeSlider: MPVolumeView = {
        let view = MPVolumeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .darkGray
        if let volumeSliderView = view.subviews.first as? UISlider {
            let imageSize = CGSize(width: 20, height: 20)
            volumeSliderView.minimumValueImage = self.imageWithImage(image: #imageLiteral(resourceName: "lowvolume-96"), scaledToSize: imageSize).withRenderingMode(.alwaysTemplate)
            volumeSliderView.maximumValueImage = self.imageWithImage(image: #imageLiteral(resourceName: "highvolume-96"), scaledToSize: imageSize).withRenderingMode(.alwaysTemplate)
        }
        return view
    }()
    
    func setupViews() {
        addSubview(volumeSlider)
        
        NSLayoutConstraint.activate([
            volumeSlider.heightAnchor.constraint(equalToConstant: 20),
            volumeSlider.centerYAnchor.constraint(equalTo: centerYAnchor),
            volumeSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            volumeSlider.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
