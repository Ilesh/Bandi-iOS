//
//  UpNextHeaderTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/9/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class UpNextHeaderTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let upNextLabel: UILabel = {
        let label = UILabel()
        label.text = "Up Next"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let shuffleButton: PlaylistControlButton = {
        let button = PlaylistControlButton(frame: .zero, title: "Shuffle", image: #imageLiteral(resourceName: "shuffle-96"))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let repeatButton: PlaylistControlButton = {
        let button = PlaylistControlButton(frame: .zero, title: "Repeat", image: #imageLiteral(resourceName: "repeat-96"))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        contentView.backgroundColor = Constants.Colors().darkTableCell
        
        contentView.addSubview(upNextLabel)
        contentView.addSubview(shuffleButton)
        contentView.addSubview(repeatButton)
        
        NSLayoutConstraint.activate([
            upNextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            upNextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            shuffleButton.heightAnchor.constraint(equalToConstant: 50),
            shuffleButton.topAnchor.constraint(equalTo: upNextLabel.bottomAnchor, constant: 10),
            shuffleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            shuffleButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10),
            
            repeatButton.heightAnchor.constraint(equalToConstant: 50),
            repeatButton.topAnchor.constraint(equalTo: upNextLabel.bottomAnchor, constant: 10),
            repeatButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            repeatButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
