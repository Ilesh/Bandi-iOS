//
//  PlaylistControl swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/9/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistControlButton: UIButton {
    
    init(frame: CGRect, title: String, image: UIImage) {
        super.init(frame: frame)
        setTitle(title, for: .normal)
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        setTitleColor(Constants.Colors().primaryColor, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(Constants.Colors().primaryDarkColor, for: .highlighted)
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 16, left: -10, bottom: 16, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -70, bottom: 0, right: 0)
        backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)
        tintColor = Constants.Colors().primaryColor
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
