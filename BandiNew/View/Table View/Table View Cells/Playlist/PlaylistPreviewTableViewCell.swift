//
//  PlaylistPreviewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/1/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistPreviewTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setHighlighted(false, animated: false)
    }
    
    let sideLength = UIScreen.main.bounds.width * 0.25
    
    var playlist: Playlist? {
        didSet {
            guard let playlist = playlist else { return }
            titleLabel.text = playlist.title
            trackCount.text = "\(playlist.size) Track" + (playlist.size != 1 ? "s" : "")
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trackCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var playlistArt: PlaylistBaseArtView = {
        let view = PlaylistBaseArtView(gradientFrame: CGRect.zero)
        view.gradient.frame = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        contentView.addSubview(playlistArt)
        contentView.addSubview(titleLabel)
        contentView.addSubview(trackCount)
        
        NSLayoutConstraint.activate([
            playlistArt.heightAnchor.constraint(equalToConstant: sideLength),
            playlistArt.widthAnchor.constraint(equalToConstant: sideLength),
            playlistArt.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            playlistArt.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: playlistArt.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trackCount.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            trackCount.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            trackCount.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
            ])
    }
    
    override func setDisabled(disabled: Bool) {
        super.setDisabled(disabled: disabled)
        if disabled {
            titleLabel.layer.opacity = 0.15
            trackCount.layer.opacity = 0.15
            playlistArt.layer.opacity = 0.15
        } else {
            titleLabel.layer.opacity = 1
            trackCount.layer.opacity = 1
            playlistArt.layer.opacity = 1
        }
    }
    
    // MARK: theme
    override func applyTheme(_ theme: AppTheme) {
        super.applyTheme(theme)
        titleLabel.textColor = theme.textColor
        trackCount.textColor = theme.subTextColor
    }
    
}

