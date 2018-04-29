//
//  CustomSearchBar.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar, UISearchBarDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        barStyle = .blackTranslucent
    }
    
    var handleSearchTextChanged: (()->())?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearchTextChanged?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
