//
//  SearchMusicCollectionViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchMusicCollectionViewCell: MusicCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Colors().primaryColor
    }
    
    var addMusic: (() -> ())?
    
    let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        if let image = UIImage(named: "plus-52")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        button.tintColor = Constants.Colors().primaryColor
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addLabel: UILabel = {
        let label = UILabel()
        label.text = "QUEUE"
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(artistLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addButton)
        
        insertSubview(addLabel, belowSubview: contentView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            artistLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),
            artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            addButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: 25),
            addButton.heightAnchor.constraint(equalToConstant: 25)
            ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTouchUp), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTouchUp), for: .touchUpOutside)
        addButton.addTarget(self, action: #selector(addButtonTouchDown), for: .touchDown)
    }
    
    @objc func addButtonTapped() {
        addMusic?()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (panRecognizer?.state == .changed) {
            let p: CGPoint = panRecognizer!.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            if p.x >= 0 {
                guard let window = UIApplication.shared.keyWindow else {
                    assert(false, "window missing")
                }
                let marginSwiped = abs(p.x) / (window.frame.width * 0.33)
                self.backgroundColor = Constants.Colors().primaryColor.withAlphaComponent(marginSwiped)
                self.addLabel.textColor = UIColor.white.withAlphaComponent(marginSwiped)
                self.contentView.frame = CGRect(x: p.x, y: 0, width: width, height: height)
                self.addLabel.frame = CGRect(x: p.x - addLabel.frame.size.width, y: 0, width: 100, height: height)
            }
        }
    }
    
    @objc override func onPan() {
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "window missing")
        }
        let p: CGPoint = panRecognizer!.translation(in: self)
        if panRecognizer?.state == .changed {
            self.setNeedsLayout()
        }
        else if panRecognizer?.state == .ended || panRecognizer?.state == .cancelled {
            if p.x > window.frame.width * 0.33 {
                self.addMusic?()
                UIView.transition(with: self.contentView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                    self.contentView.backgroundColor = Constants.Colors().primaryColor
                }, completion: { completed in
                    UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        self.contentView.backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
                    })
                })
            }
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                self.addLabel.frame = CGRect(x: 0 - self.addLabel.frame.size.width, y: 0, width: 100, height: height)
                self.setNeedsLayout()
                self.layoutIfNeeded()
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

