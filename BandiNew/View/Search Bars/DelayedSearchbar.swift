//
//  DelayedSearchBar.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class DelayedSearchbar: CustomSearchBar {
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchBarTextChanged), object: nil)
        self.perform(#selector(searchBarTextChanged), with: nil, afterDelay: 0.25)
    }
    
    @objc func searchBarTextChanged() {
        handleSearchTextChanged?()
    }
    
}
