//
//  SongPreviewView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/6/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import MarqueeLabelSwift

class SongPreviewView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var song: Song? {
        didSet {
            titleLabel.text = song?.title
            artistLabel.text = song?.artist
            song?.fetchAThumbnail(requestedImageType: "wide", completion: { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            })
        }
    }

    let darkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let darkView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    let titleLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, duration: 20, fadeLength: 0)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors().primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        
        addSubview(darkView)
        addSubview(blurView)
        addSubview(titleLabel)
        addSubview(artistLabel)
        
        NSLayoutConstraint.activate([
                darkView.topAnchor.constraint(equalTo: topAnchor),
                darkView.leadingAnchor.constraint(equalTo: leadingAnchor),
                darkView.trailingAnchor.constraint(equalTo: trailingAnchor),
                darkView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
                blurView.topAnchor.constraint(equalTo: topAnchor),
                blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
                artistLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
                artistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
                
                titleLabel.bottomAnchor.constraint(equalTo: artistLabel.topAnchor, constant: -5),
                titleLabel.leadingAnchor.constraint(equalTo: artistLabel.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: artistLabel.trailingAnchor)
            ])
        
    }
    
}
