//
//  MusicCollectionViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class MusicCollectionViewCell: BaseCollectionViewCell {
    
    var handleAddRemoveButtonTapped: (() ->())?
    
    var music: Music? {
        didSet {
            titleLabel.text = music?.title
            artistLabel.text = music?.artist
            let url = URL(string: music!.thumbnailURLString!)
            if let thumbnailData = try? Data(contentsOf: url!) {
                thumbnailImageView.image = UIImage(data: thumbnailData)
            }
        }
    }
    
    var isAdd: Bool? {
        didSet {
            if isAdd! {
                self.addRemoveButton.backgroundColor = Constants.Colors().primaryColor
            } else {
                self.addRemoveButton.backgroundColor = Constants.Colors().secondaryColor
            }
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Heavy", size: 15)
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir-MediumOblique", size: 12)
        return label
    }()
    
    let addRemoveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        return button
    }()
    
    override func setupViews() {
        backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        addSubview(thumbnailImageView)
        addSubview(artistLabel)
        addSubview(titleLabel)
        addSubview(addRemoveButton)
        
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
            
            addRemoveButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            addRemoveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addRemoveButton.widthAnchor.constraint(equalToConstant: 35),
            addRemoveButton.heightAnchor.constraint(equalToConstant: 35)
            ])
        
        addRemoveButton.addTarget(self, action: #selector(addRemoveButtonTapped), for: .touchUpInside)

    }
    
    @objc func addRemoveButtonTapped() {
        handleAddRemoveButtonTapped?()
    }
    
}
