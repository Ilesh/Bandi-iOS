//
//  Constants.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Colors {
        let textGray = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1);
        
        let primaryColor = UIColor(red: 0.61, green: 0.15, blue: 0.69, alpha: 1.0);
        let primaryLightColor = UIColor(red: 0.82, green: 0.36, blue: 0.89, alpha: 1.0);
        let primaryDarkColor = UIColor(red: 0.42, green: 0.00, blue: 0.50, alpha: 1.0);
        let primaryTextColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0);
        let secondaryColor = UIColor(red: 0.85, green: 0.11, blue: 0.38, alpha: 1.0);
        let secondaryLightColor = UIColor(red: 1.00, green: 0.36, blue: 0.55, alpha: 1.0);
        let secondaryDarkColor = UIColor(red: 0.63, green: 0.00, blue: 0.22, alpha: 1.0);
        let secondaryTextColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0);
    }
    
}

extension UIWindow {
    /// Returns the currently visible view controller if any reachable within the window.
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }
    
    /// Recursively follows navigation controllers, tab bar controllers and modal presented view controllers starting
    /// from the given view controller to find the currently visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to start the recursive search from.
    /// - Returns: The view controller that is most probably visible on screen right now.
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)
            
        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)
            
        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)
            
        default:
            return viewController
        }
    }
}

//public extension UIWindow {
//    public var visibleViewController: UIViewController? {
//        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
//    }
//
//    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
//        if let nc = vc as? UINavigationController {
//            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
//        } else if let tc = vc as? UITabBarController {
//            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
//        } else {
//            if let pvc = vc?.presentedViewController {
//                return UIWindow.getVisibleViewControllerFrom(pvc)
//            } else {
//                return vc
//            }
//        }
//    }
//}
