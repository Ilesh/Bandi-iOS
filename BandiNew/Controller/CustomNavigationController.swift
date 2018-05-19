//
//  CustomNavigationController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/30/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    override func viewDidLoad() {
        navigationBar.shouldRemoveShadow(true)
        
//        let bgimage = imageWithGradient(startColor: Constants.Colors().secondaryColor, endColor: Constants.Colors().themeBlue, size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))
//        navigationBar.barTintColor = UIColor(patternImage: bgimage!)
        setUpTheming()
    }
    
    func imageWithGradient(startColor:UIColor, endColor:UIColor, size:CGSize, horizontally:Bool = true) -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        if horizontally {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomNavigationController: Themed {
    func applyTheme(_ theme: AppTheme) {
        navigationBar.isTranslucent = theme.isNavBarTranslucent
        navigationBar.barStyle = theme.barStyle
        navigationBar.tintColor = theme.tintColor
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : theme.textColor]
    }
}
