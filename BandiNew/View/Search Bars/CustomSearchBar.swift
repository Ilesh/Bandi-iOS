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
        tintColor = Constants.Colors().secondaryColor
        keyboardAppearance = .dark
        
        let textFieldInsideUISearchBar = value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = .white
        textFieldInsideUISearchBar?.font = UIFont(name: "AvenirNext", size: 10)
    }
    
    var handleSearchTextChanged: (()->())?
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        setShowsCancelButton(false, animated: true)
        resignFirstResponder()
        endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearchTextChanged?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
