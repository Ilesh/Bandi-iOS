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
    
    let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        if let image = UIImage(named: "handle-60")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .lightGray
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let removelabel: UILabel = {
        let label = UILabel()
        label.text = "REMOVE"
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(artistLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(removeButton)
        
        insertSubview(removelabel, belowSubview: contentView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -13),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            artistLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -13),
            artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            removeButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            removeButton.widthAnchor.constraint(equalToConstant: 22),
            removeButton.heightAnchor.constraint(equalToConstant: 22)
            ])
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(removeButtonLongGesture(_:)))
        removeButton.addGestureRecognizer(longPressGesture)
    }
    
    @objc func removeButtonLongGesture(_ sender: UILongPressGestureRecognizer) {
        if let parentCollectionView = self.superview as? QueueMusicCollectionView {
            switch(sender.state) {
                case .began:
                    guard let selectedIndexPath = parentCollectionView.indexPathForItem(at: sender.location(in: parentCollectionView)) else {
                        break
                    }
                    parentCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                    UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.contentView.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
                        self.removeButton.tintColor = Constants.Colors().secondaryColor
                    })
                case .changed:
                    let position = CGPoint(x: self.frame.width / 2, y: sender.location(in: parentCollectionView).y)
                    parentCollectionView.updateInteractiveMovementTargetPosition(position)
                case .ended:
                    UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.contentView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
                        self.removeButton.tintColor = .lightGray
                    })
                    parentCollectionView.endInteractiveMovement()
                default:
                    parentCollectionView.cancelInteractiveMovement()
            }
        }

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
                self.contentView.frame = CGRect(x: p.x, y: 0, width: width, height: height)
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
            if p.x < 0 && abs(p.x) > window.frame.width * 0.33 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.contentView.frame = CGRect(x: -width, y: 0, width: width, height: height)
                    self.removelabel.frame = CGRect(x: -160, y: 0, width: 150, height: height)
                }, completion: { completed in
                    UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
                    }, completion: { completed in
                        self.removeMusic?()
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                    })
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
