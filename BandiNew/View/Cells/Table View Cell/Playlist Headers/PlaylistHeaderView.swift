//
//  PlaylistHeaderView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/7/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistHeaderView: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setUpTheming()
    }

    let playlistSideLength = UIScreen.main.bounds.width * 0.373
    
    lazy var playlistImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors().primaryColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        let gradient = StaticGradient()
        gradient.frame = CGRect(x: 0, y: 0, width: self.playlistSideLength, height: self.playlistSideLength)
        view.layer.addSublayer(gradient)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let playlistName: UILabel = {
        let label = UILabel()
        label.text = "TEST PLAYLIST"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(playlistImageContainer)
        addSubview(playlistName)
        
        playlistImageContainer.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            playlistImageContainer.widthAnchor.constraint(equalToConstant: playlistSideLength),
            playlistImageContainer.heightAnchor.constraint(equalToConstant: playlistSideLength),
            playlistImageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            playlistImageContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            blurView.topAnchor.constraint(equalTo: playlistImageContainer.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: playlistImageContainer.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: playlistImageContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: playlistImageContainer.trailingAnchor),
            
            playlistName.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            playlistName.leadingAnchor.constraint(equalTo: playlistImageContainer.trailingAnchor, constant: 15),
            playlistName.trailingAnchor.constraint(equalTo: trailingAnchor),
            playlistName.heightAnchor.constraint(equalToConstant: 15),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaylistHeaderView: Themed {
    func applyTheme(_ theme: AppTheme) {
        playlistName.textColor = theme.textColor
        playlistImageContainer.layer.borderColor = theme.viewBorderColor
    }
}
