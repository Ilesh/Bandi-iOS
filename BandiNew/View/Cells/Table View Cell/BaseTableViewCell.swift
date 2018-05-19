//
//  BaseTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell, Themed {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpTheming()
    }
    
    func applyTheme(_ theme: AppTheme) {
        textLabel?.textColor = theme.textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
