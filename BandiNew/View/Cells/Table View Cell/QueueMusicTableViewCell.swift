//
//  QueueMusicTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueMusicTableViewCell: MusicTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    var removeMusic: (()->())?
    
    let removelabel: PaddingLabel = {
        let label = PaddingLabel()
        label.leftInset = 10
        label.text = "REMOVE"
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(interactionButton)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 55),
            
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 15),
            artistLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            interactionButton.topAnchor.constraint(equalTo: self.topAnchor),
            interactionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            interactionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            interactionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
