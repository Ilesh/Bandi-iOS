//
//  TabBarController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
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
