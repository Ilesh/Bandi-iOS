//
//  QueueHeaderView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/8/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueHeaderViewCell: PlaylistHeaderCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    var linkButtonTapped: (()->())?
    
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
    
    let editAlert = QueueEditAlertController()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(linkButton)
        addSubview(editButton)
        
        NSLayoutConstraint.activate([
            linkButton.heightAnchor.constraint(equalToConstant: 30),
            linkButton.widthAnchor.constraint(equalToConstant: 115),
            linkButton.leadingAnchor.constraint(equalTo: playlistImageContainer.trailingAnchor, constant: 15),
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            ])
        
        linkButton.addTarget(self, action: #selector(linkTap), for: .touchUpInside)
    }
    
    @objc func linkTap() {
        linkButtonTapped?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
