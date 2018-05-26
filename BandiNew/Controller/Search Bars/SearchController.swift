//
//  SearchController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/7/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }
    
    func setup() {
        setUpTheming()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchController: Themed {
    func applyTheme(_ theme: AppTheme) {
        searchBar.keyboardAppearance = theme.keyboardAppearance
    }
}
