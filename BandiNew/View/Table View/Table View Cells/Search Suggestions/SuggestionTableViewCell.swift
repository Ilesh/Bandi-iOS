//
//  SuggestionTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setUpTheming()
    }
    
    let selectedView = UIView()
    let searchImage = UIImageView(image: #imageLiteral(resourceName: "search-90").withRenderingMode(.alwaysTemplate))
    
    func setupViews() {
        selectedBackgroundView = selectedView
        
        searchImage.contentMode = .scaleAspectFit
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(searchImage)
        NSLayoutConstraint.activate([
            searchImage.widthAnchor.constraint(equalToConstant: 20),
            searchImage.heightAnchor.constraint(equalToConstant: 20),
            searchImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            searchImage.topAnchor.constraint(equalTo: topAnchor, constant: 20)
            ])
    }
    
    override func applyTheme(_ theme: AppTheme) {
        super.applyTheme(theme)
        textLabel?.textColor = theme.textColor
        selectedView.backgroundColor = theme.tintColor
        searchImage.tintColor = theme.subTextColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
