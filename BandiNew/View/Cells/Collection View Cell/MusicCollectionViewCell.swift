//
//  MusicCollectionViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class MusicCollectionViewCell: BaseCollectionViewCell, UIGestureRecognizerDelegate {
    
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
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Heavy", size: 15)
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir-MediumOblique", size: 12)
        return label
    }()
    
    override func setupViews() {
        contentView.backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        panRecognizer?.delegate = self
        addGestureRecognizer(panRecognizer!)
    }
    
    @objc func onPan() {
        // OVERRIDE
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //return true
        let doesBegin = abs((panRecognizer!.velocity(in: panRecognizer!.view)).x) > abs((panRecognizer!.velocity(in: panRecognizer!.view)).y)
        if doesBegin {
            swipeStarted?()
        }
        return doesBegin
    }
    
}
