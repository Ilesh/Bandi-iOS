//
//  SearchMusicTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchMusicTableViewCell: MusicTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    var addMusic: (() -> ())?
    var musicTapped: (()->())?
    
    let addLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.leftInset = 10
        label.text = "QUEUE"
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        label.textColor = .white
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus-96")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Constants.Colors().primaryColor
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        
        insertSubview(addLabel, belowSubview: contentView)
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(interactionButton)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 55),
            
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 15),
            artistLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -5),
            artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            interactionButton.topAnchor.constraint(equalTo: self.topAnchor),
            interactionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            interactionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            interactionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            addButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        interactionButton.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTouchUp), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTouchUp), for: .touchUpOutside)
        addButton.addTarget(self, action: #selector(addButtonTouchDown), for: .touchDown)
    }
    
    @objc func cellTapped() {
        print("here")
        self.musicTapped?()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBar = appDelegate.mainTabBarController
        let musicDetails = tabBar.musicDetailsController
        musicDetails.showLoading()
        musicDetails.pause()
        tabBar.presentPopupBar(withContentViewController: musicDetails, openPopup: true, animated: true, completion: nil)
        MusicFetcher.fetchYoutubeVideoUrl(address: APIKeys().serverAddress, videoID: (music?.youtubeVideoID)!, quality: "CHANGE THIS", handler: { (videoURL) in
            DispatchQueue.main.async {
                if let trimmedURL = videoURL?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
                    //print(trimmedURL)
                    musicDetails.playingMusic = self.music
                    musicDetails.updateVideo(videoURLString: trimmedURL)
                    musicDetails.play()
                }
            }
        })
    }
    
    @objc func addButtonTapped() {
        print("asdf")
        self.addMusic?()
        TEMPSessionData.queueMusic.append(music!)
    }
    
    @objc func addButtonTouchDown() {
        UIView.transition(with: addButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.addButton.tintColor = Constants.Colors().primaryLightColor
        })
    }
    
    @objc func addButtonTouchUp() {
        UIView.transition(with: addButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.addButton.tintColor = Constants.Colors().primaryColor
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
