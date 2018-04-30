//
//  PlatformPickerPopupView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlatformPickerPopupView: PopupView {
    
    override init(heightRatio: CGFloat, title: String) {
        super.init(heightRatio: heightRatio, title: title)
    }
    
    lazy var platformPicker: PlatformPicker = {
        let platP = PlatformPicker(frame: .zero)
        platP.translatesAutoresizingMaskIntoConstraints = false
        return platP
    }()
    
    override func setupViews() {
        super.setupViews()
        setupContent(content: platformPicker)
    }
    
}
