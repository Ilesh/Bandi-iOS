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
        
        let libraryTabController = CustomNavigationController(rootViewController: LibraryTabController())
        let searchTabController = CustomNavigationController(rootViewController: SearchYoutubeController(style: .plain))
        let queueTabController = CustomNavigationController(rootViewController: QueueDetailsController(style: .plain))
        
        let vcData: [(vc: UIViewController, title: String)] = [
            (libraryTabController, "Library"),
            (searchTabController, "Search"),
            (queueTabController, "Queue"),
        ]
        
        var tabViewControllers: [UIViewController] = []
        for item in vcData {
            //item.vc.tabBarItem.image = item.image.withRenderingMode(.alwaysTemplate)
            item.vc.tabBarItem.title = item.title
            item.vc.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: -3, bottom: -2, right: -3)
            tabViewControllers.append(item.vc)
        }
        
        tabBar.layer.borderWidth = 0
        viewControllers = tabViewControllers
        selectedIndex = 1
        
        setupViews()
        setUpTheming()
    }
    
    // TODO: doing this made search table red gone?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popupItem.title = "Not Playing"
        popupItem.progress = 0
        presentPopupBar(withContentViewController: musicDetailsController, openPopup: false, animated: false, completion: nil)
        musicDetailsController.viewDidLoad()
    }
    
    let musicDetailsController = MusicDetailsController()
    
    func setupViews() {
        popupBar.inheritsVisualStyleFromDockingView = false
        popupBar.imageView.contentMode = .scaleAspectFill
        popupBar.imageView.layer.cornerRadius = 5
        popupBar.imageView.clipsToBounds = true
        popupInteractionStyle = .drag
        popupContentView.popupCloseButtonStyle = .chevron
        popupBar.marqueeScrollEnabled = false
        popupBar.progressViewStyle = .top
    }
    
}

// MARK: - Theme
extension CustomTabBarController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tabBar.barTintColor = theme.barBackgroundColor
        tabBar.tintColor = theme.tintColor
        tabBar.unselectedItemTintColor = theme.barUnselectedTextColor
        popupBar.isTranslucent = false
        popupBar.backgroundColor = theme.tableBackgroundColor
        popupBar.barTintColor = theme.tableBackgroundColor
        popupBar.tintColor = theme.textColor
        popupBar.backgroundStyle = theme.popBarBackgroundStyle
        popupBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18) as Any, .foregroundColor: theme.textColor]
        popupBar.subtitleTextAttributes = [.font: UIFont.systemFont(ofSize: 13) as Any, .foregroundColor: theme.subTextColor]
        //updatePopupBarAppearance()
    }
}
