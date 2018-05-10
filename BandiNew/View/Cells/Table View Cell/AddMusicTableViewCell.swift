//
//  AddMusicTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/9/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddMusicTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let addLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Music"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        contentView.addSubview(addLabel)
        
        NSLayoutConstraint.activate([
            addLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            addLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
