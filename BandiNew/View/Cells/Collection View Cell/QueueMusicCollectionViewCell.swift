//
//  QueueMusicCollectionViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueMusicCollectionViewCell: MusicCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var handleRemoveButtonTapped: (()->())?
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.Colors().secondaryColor
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        addSubview(thumbnailImageView)
        addSubview(artistLabel)
        addSubview(titleLabel)
        addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            artistLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            artistLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
            removeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            removeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            removeButton.widthAnchor.constraint(equalToConstant: 35),
            removeButton.heightAnchor.constraint(equalToConstant: 35)
            ])
        
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    @objc func removeButtonTapped() {
        handleRemoveButtonTapped?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
