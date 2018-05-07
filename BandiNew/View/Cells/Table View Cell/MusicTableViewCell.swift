//
//  MusicTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class MusicTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
    }
    
    var panRecognizer: UIPanGestureRecognizer?
    var swipeStarted: (()->())?
    
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
    
    let interactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = .clear
        return button
    }()
    
    let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors().textGray
        label.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "Avenir-Heavy", size: 15)
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.italicSystemFont(ofSize: 13) //UIFont(name: "Avenir-MediumOblique", size: 12)
        return label
    }()
    
//    override func prepareForReuse() {
//        titleLabel.text = music?.title
//        artistLabel.text = music?.artist
//        let url = URL(string: music!.thumbnailURLString!)
//        if let thumbnailData = try? Data(contentsOf: url!) {
//            thumbnailImageView.image = UIImage(data: thumbnailData)
//        }
//    }
    
//    @objc func onPan() {
//
//    }
    
//    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        let doesBegin = abs((panRecognizer!.velocity(in: panRecognizer!.view)).x) > abs((panRecognizer!.velocity(in: panRecognizer!.view)).y)
//        if doesBegin {
//            swipeStarted?()
//        }
//        return doesBegin
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
