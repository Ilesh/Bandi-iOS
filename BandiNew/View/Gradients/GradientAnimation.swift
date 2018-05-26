//
//  GradientAnimation.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import QuartzCore

class GradientAnimation: CAGradientLayer, CAAnimationDelegate {
    
    override init() {
        super.init()
        setupAnimation()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        setupAnimation()
    }
    
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = Constants.Colors().primaryColor.cgColor
    let gradientTwo = Constants.Colors().secondaryColor.cgColor
    let gradientThree = #colorLiteral(red: 0.273070025, green: 0.6851184114, blue: 1, alpha: 1).cgColor
    
    func setupAnimation() {
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        colors = gradientSet[currentGradient]
        startPoint = CGPoint(x:0, y:0)
        endPoint = CGPoint(x:1, y:1)
        drawsAsynchronously = true
        zPosition = -1
        
        animateGradient()
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.delegate = self
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

