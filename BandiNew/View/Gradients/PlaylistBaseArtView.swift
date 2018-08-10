//
//  PlaylistBaseArt swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/1/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistBaseArtView: UIView {
    
    init(gradientFrame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.borderWidth = 1
        gradient.frame = gradientFrame
        layer.addSublayer(gradient)
        setupView()
        setUpTheming()
    }
    
    let gradient = StaticGradient()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupView() {
        addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Theme
extension PlaylistBaseArtView: Themed {
    func applyTheme(_ theme: AppTheme) {
        layer.borderColor = theme.viewBorderColor
    }
}
