//
//  QueueHeaderView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/8/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueHeaderViewCell: PlaylistHeaderView {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    var linkButtonTapped: (()->())?
    var editButtonTapped: (()->())?
    
    let linkButton: UIButton = {
        let button = UIButton()
        button.setTitle("bandi.link", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = Constants.Colors().primaryColor
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "3dots-96")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.backgroundColor = Constants.Colors().primaryColor
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let editAlert = QueueEditAlertController()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(linkButton)
        addSubview(editButton)
        
        NSLayoutConstraint.activate([
            linkButton.heightAnchor.constraint(equalToConstant: 30),
            linkButton.leadingAnchor.constraint(equalTo: playlistImageContainer.trailingAnchor, constant: 15),
            linkButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -15),
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            ])
        
        linkButton.addTarget(self, action: #selector(linkTap), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTap), for: .touchUpInside)
    }
    
    @objc func linkTap() {
        linkButtonTapped?()
    }
    
    @objc func editTap() {
        editButtonTapped?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
