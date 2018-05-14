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
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.trailingAnchor.constraint(equalTo: centerXAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
