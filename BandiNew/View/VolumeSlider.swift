//
//  VolumeSlider.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/4/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import MediaPlayer

class VolumeSlider: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    lazy var volumeSlider: MPVolumeView = {
        let view = MPVolumeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .darkGray
        return view
    }()
    
    let lowVolume: UIImageView = {
        let image = UIImage(named: "lowvolume-96")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.tintColor = .darkGray
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let highVolume: UIImageView = {
        let image = UIImage(named: "highvolume-96")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.tintColor = .darkGray
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        self.addSubview(volumeSlider)
        self.addSubview(lowVolume)
        self.addSubview(highVolume)
        
        NSLayoutConstraint.activate([
            lowVolume.heightAnchor.constraint(equalToConstant: 20),
            lowVolume.widthAnchor.constraint(equalToConstant: 20),
            lowVolume.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lowVolume.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -1),
            
            volumeSlider.topAnchor.constraint(equalTo: self.topAnchor),
            volumeSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            volumeSlider.leadingAnchor.constraint(equalTo: lowVolume.trailingAnchor, constant: 2),
            volumeSlider.trailingAnchor.constraint(equalTo: highVolume.leadingAnchor, constant: -10),
            
            highVolume.heightAnchor.constraint(equalToConstant: 20),
            highVolume.widthAnchor.constraint(equalToConstant: 20),
            highVolume.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            highVolume.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -1),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
