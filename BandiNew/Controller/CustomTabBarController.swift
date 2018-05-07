//
//  CustomTabBarController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import AVFoundation
import LNPopupController

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchTabController = CustomNavigationController(rootViewController: SearchTabController())

        let queueTabController = CustomNavigationController(rootViewController: QueueTabController())
        
        let linkTabController = LinkTabController()
        
        let vcData: [(vc: UIViewController, title: String)] = [
            (searchTabController, "Search"),
            (queueTabController, "Queue"),
            (linkTabController, "Link")
        ]
        
        var tabViewControllers: [UIViewController] = []
        for item in vcData {
            //item.vc.tabBarItem.image = item.image.withRenderingMode(.alwaysTemplate)
            item.vc.tabBarItem.title = item.title
            item.vc.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: -3, bottom: -2, right: -3)
            tabViewControllers.append(item.vc)
        }
        
        setTransparentTabBar(isSet: false)
        tabBar.tintColor = Constants.Colors().primaryLightColor
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = true
        
        viewControllers = tabViewControllers
        selectedIndex = 0
        
        setupViews()
        setupPopupStyle()
    }
    
    lazy var musicDetailsController: MusicDetailsController = {
        let yp = MusicDetailsController()
        return yp
    }()
    
    func setupViews() {
        popupInteractionStyle = .drag
        popupBar.barStyle = .custom
        popupContentView.popupCloseButtonStyle = .chevron
        popupBar.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1).withAlphaComponent(0.99)
        popupBar.isTranslucent = false
        popupBar.marqueeScrollEnabled = true
        popupBar.progressViewStyle = .default
        popupBar.tintColor = Constants.Colors().primaryColor
    }
    
    func setupPopupStyle() {
        LNPopupBar.appearance(whenContainedInInstancesOf: [UIViewController.self]).titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 17) as Any, .foregroundColor: Constants.Colors().textGray]
        LNPopupBar.appearance(whenContainedInInstancesOf: [UIViewController.self]).subtitleTextAttributes = [.font: UIFont.italicSystemFont(ofSize: 13) as Any, .foregroundColor: UIColor.lightGray]
        
    }
    
    func setTransparentTabBar(isSet: Bool) {
        if isSet {
            tabBar.barStyle = .default
            tabBar.barTintColor = .clear
            tabBar.backgroundImage = UIImage()
            tabBar.unselectedItemTintColor = .black
        }
        else {
            tabBar.barStyle = .blackOpaque
            tabBar.barTintColor = .black
            tabBar.backgroundImage = nil
            tabBar.backgroundColor = .black
            tabBar.unselectedItemTintColor = .lightGray
        }
    }
    
}
