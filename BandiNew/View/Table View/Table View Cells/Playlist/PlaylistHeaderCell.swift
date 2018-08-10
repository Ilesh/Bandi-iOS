//
//  PlaylistHeaderView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/7/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistHeaderCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setUpTheming()
    }

    let playlistSideLength = UIScreen.main.bounds.width * 0.373
    var editButtonTapped: (()->())?
    
    var playlist: Playlist? {
        didSet {
            guard let playlist = playlist else { return }
            playlistName.text = playlist.title!
        }
    }
    
    lazy var playlistImageContainer: PlaylistBaseArtView = {
        let view = PlaylistBaseArtView(gradientFrame: CGRect(x: 0, y: 0, width: self.playlistSideLength, height: self.playlistSideLength))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let playlistName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    func setupViews() {
        addSubview(playlistImageContainer)
        addSubview(playlistName)
        addSubview(editButton)
        
        NSLayoutConstraint.activate([
            playlistImageContainer.widthAnchor.constraint(equalToConstant: playlistSideLength),
            playlistImageContainer.heightAnchor.constraint(equalToConstant: playlistSideLength),
            playlistImageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            playlistImageContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            playlistName.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            playlistName.leadingAnchor.constraint(equalTo: playlistImageContainer.trailingAnchor, constant: 15),
            playlistName.trailingAnchor.constraint(equalTo: trailingAnchor),
            playlistName.heightAnchor.constraint(equalToConstant: 15),
            
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            ])
        
        editButton.addTarget(self, action: #selector(editTap), for: .touchUpInside)
    }
    
    @objc func editTap() {
        editButtonTapped?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaylistHeaderCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        playlistName.textColor = theme.textColor
    }
}
