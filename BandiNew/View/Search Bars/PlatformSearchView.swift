//
//  PlatformSearchView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlatformSearchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    var handleDelayedSearchTextChanged: (()->())?
    
    lazy var searchBar: DelayedSearchbar = {
        let sb = DelayedSearchbar(frame: .zero)
        sb.handleSearchTextChanged = {
            self.handleDelayedSearchTextChanged?()
        }
        sb.tintColor = Constants.Colors().primaryColor
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    lazy var platformPickerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var platformPickerPopup: PlatformPickerPopupView = {
        let popup = PlatformPickerPopupView(heightRatio: 0.5, title: "Where to search?")
        return popup
    }()
    
    func setupViews() {
        self.addSubview(searchBar)
        self.addSubview(platformPickerButton)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: platformPickerButton.leadingAnchor),
            
            platformPickerButton.topAnchor.constraint(equalTo: self.topAnchor),
            platformPickerButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            platformPickerButton.widthAnchor.constraint(equalToConstant: 50),
            platformPickerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
        
        platformPickerButton.addTarget(self, action: #selector(platformPickerButtonTapped), for: .touchUpInside)
    }
    
    @objc func platformPickerButtonTapped() {
        endEditing(true)
        platformPickerPopup.showPopupMenu()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
