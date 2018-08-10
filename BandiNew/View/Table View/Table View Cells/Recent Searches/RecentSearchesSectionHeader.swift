//
//  RecentSearchesSectionHeader.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/14/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class RecentSearchesSectionHeader: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setUpTheming()
    }
    
    var clearPressed: (()->())?
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(Constants.Colors().primaryColor, for: .normal)
        button.contentHorizontalAlignment = .right
        button.tintColor = Constants.Colors().primaryColor
        button.addTarget(self, action: #selector(clearPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        addSubview(label)
        addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            clearButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            clearButton.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    
    @objc func clearPress() {
        clearPressed?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Theme
extension RecentSearchesSectionHeader: Themed {
    func applyTheme(_ theme: AppTheme) {
        label.textColor = theme.textColor
    }
}
