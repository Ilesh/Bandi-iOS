//
//  PlaylistControlsTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/8/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistControlsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let playButton: PlaylistControlButton = {
        let button = PlaylistControlButton(frame: .zero, title: "Play", image: UIImage(named: "play-100")!)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shuffleButton: PlaylistControlButton = {
        let button = PlaylistControlButton(frame: .zero, title: "Shuffle", image: UIImage(named: "shuffle-96")!)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        
        addSubview(playButton)
        addSubview(shuffleButton)
        
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            playButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            shuffleButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            shuffleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            shuffleButton.heightAnchor.constraint(equalToConstant: 50),
            shuffleButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
