//
//  MusicTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import LayoutKit

class MusicTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Constants.Colors().darkTableCell
        setupViews()
    }
    
    var panRecognizer: UIPanGestureRecognizer?
    var swipeStarted: (()->())?
    var thumbnailImage: UIImage?
    
    var music: Music? {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = self.music?.title
                self.artistLabel.text = self.music?.artist
                self.thumbnailImageView.image = self.music?.thumbnailImage
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
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    func setupViews(){ }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
