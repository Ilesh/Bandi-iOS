//
//  LibraryTabController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/9/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class LibraryTabController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBar = navigationController {
            navBar.navigationBar.prefersLargeTitles = true
        }
        
        title = "Library"
        setupViews()
    }
    
    func setupViews() {
        
    }
    
}
