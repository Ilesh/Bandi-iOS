//
//  PlaylistHeaderTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/7/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistHeaderTableViewCell: UITableViewHeaderFooterView {
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let test: PlaylistHeaderView = {
        let view = PlaylistHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        
        contentView.addSubview(test)
        
        NSLayoutConstraint.activate([
            test.topAnchor.constraint(equalTo: contentView.topAnchor),
            test.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            test.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            test.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
