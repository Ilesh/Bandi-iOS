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
        selectedBackgroundView = selectedBackground
        setUpTheming()
        tintColor = baseTintColor
    }
    
    let selectedBackground = UIView()
    var baseTintColor: UIColor = .blue
    var baseBackgroundColor: UIColor = .clear
    var isDisabled = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTheme(_ theme: AppTheme) {
        textLabel?.textColor = theme.textColor
        baseTintColor = theme.subTextColor
        selectedBackground.backgroundColor = theme.tableCellBackgroundColor
        baseBackgroundColor = theme.tableBackgroundColor
    }
    
    func configureSelected(_ selected: Bool) {
        tintColor = selected ? Constants.Colors().primaryColor : baseTintColor
        textLabel?.textColor = AppThemeProvider.shared.currentTheme.textColor
        if selected {
            backgroundColor = selectedBackground.backgroundColor
        } else {
            backgroundColor = baseBackgroundColor
        }
    }
    
    func setDisabled(disabled: Bool) {
        isDisabled = disabled
        textLabel?.layer.opacity = 0.15
    }
    
}
