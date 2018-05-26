//
//  StaticGradient.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/7/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import QuartzCore

class StaticGradient: CAGradientLayer {
    
    override init() {
        super.init()
        setup()
    }
    
    override init(layer: Any) {
        super.init()
        setup()
    }
    
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientColors =  [Constants.Colors().primaryColor.cgColor,
                           Constants.Colors().secondaryColor.cgColor,
                           /*UIColor(red: 0.85, green: 0.11, blue: 0.38, alpha: 1.0).cgColor*/]
    
    func setup() {
        colors = gradientColors
        startPoint = CGPoint(x: 0.15, y: 0.15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

