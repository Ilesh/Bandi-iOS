//
//  QueueMusicCollectionViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueMusicCollectionViewCell: MusicCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Colors().secondaryColor
    }
    
    var removeMusic: (()->())?
    
    let removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        if let image = UIImage(named: "minus-52")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        button.tintColor = Constants.Colors().secondaryColor
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let removelabel: UILabel = {
        let label = UILabel()
        label.text = "REMOVE"
        label.font = UIFont(name: "Avenir-Heavy", size: 22)
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailImageView)
        addSubview(artistLabel)
        addSubview(titleLabel)
        addSubview(removeButton)
        
        insertSubview(removelabel, belowSubview: contentView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            artistLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -10),
            artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            removeButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            removeButton.widthAnchor.constraint(equalToConstant: 25),
            removeButton.heightAnchor.constraint(equalToConstant: 25)
            ])
        
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTouchUp), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTouchUp), for: .touchUpOutside)
        removeButton.addTarget(self, action: #selector(removeButtonTouchDown), for: .touchDown)
    }
    
    @objc func removeButtonTapped() {
        removeMusic?()
    }
    
    @objc func removeButtonTouchDown() {
        UIView.transition(with: removeButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.removeButton.tintColor = Constants.Colors().secondaryLightColor
        })
    }
    
    @objc func removeButtonTouchUp() {
        UIView.transition(with: removeButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.removeButton.tintColor = Constants.Colors().secondaryColor
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (panRecognizer?.state == .changed) {
            let p: CGPoint = panRecognizer!.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            if p.x <= 0 {
                guard let window = UIApplication.shared.keyWindow else {
                    assert(false, "window missing")
                }
                let marginSwiped = abs(p.x) / (window.frame.width * 0.33)
                self.backgroundColor = Constants.Colors().secondaryColor.withAlphaComponent(marginSwiped)
                self.removelabel.textColor = UIColor.white.withAlphaComponent(marginSwiped)
                self.contentView.frame = CGRect(x: p.x, y: 0, width: width, height: height);
                self.removelabel.frame = CGRect(x: p.x + width + 10, y: 0, width: 150, height: height)
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
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            if abs(p.x) > window.frame.width * 0.33 {
                self.removeMusic?()
                UIView.transition(with: self.contentView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                    self.contentView.backgroundColor = Constants.Colors().secondaryColor
                }, completion: { completed in
                    UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.contentView.backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
                    })
                })
                UIView.animate(withDuration: 0.2, animations: {
                    self.contentView.frame = CGRect(x: -width, y: 0, width: 0, height: height);
                    self.removelabel.frame = CGRect(x: 0, y: 0, width: 150, height: height)
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.contentView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    self.removelabel.frame = CGRect(x: width + 160, y: 0, width: 150, height: height)
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
