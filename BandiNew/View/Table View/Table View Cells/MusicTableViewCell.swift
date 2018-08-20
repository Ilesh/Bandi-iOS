//
//  MusicTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import LayoutKit

class MusicTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    var panRecognizer: UIPanGestureRecognizer?
    var swipeStarted: (()->())?
    var thumbnailImage: UIImage?
    var reuseId = 1
    
    var music: Song? {
        didSet {
            self.titleLabel.text = self.music?.title
            self.artistLabel.text = self.music?.artist
            if self.music?.liveBroadcastContent == "live" {
                print("LIVE VIDEO FOUND")
                self.durationLabel.text = "LIVE"
            } else {
                self.durationLabel.text = self.music?.length?.decodedYoutubeTime()
            }
            let currentReuseId = reuseId
            music?.fetchAThumbnail(requestedImageType: "wide", completion: { image in
                guard currentReuseId == self.reuseId else { return }
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseId = reuseId + 1
        thumbnailImageView.image = UIImage()
    }
    
    let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors().textGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let durationLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.topInset = 2
        label.bottomInset = 2
        label.leftInset = 2
        label.rightInset = 2
        label.text = "3:42"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.77)
        label.clipsToBounds = true
        label.layer.cornerRadius = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){ }
    
    override func setDisabled(disabled: Bool) {
        super.setDisabled(disabled: disabled)
        if disabled {
            titleLabel.layer.opacity = 0.15
            artistLabel.layer.opacity = 0.15
            thumbnailImageView.layer.opacity = 0.15
        } else {
            titleLabel.layer.opacity = 1
            artistLabel.layer.opacity = 1
            thumbnailImageView.layer.opacity = 1
        }
    }
    
    override func applyTheme(_ theme: AppTheme) {
        super.applyTheme(theme)
        titleLabel.textColor = theme.textColor
        artistLabel.textColor = theme.subTextColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

