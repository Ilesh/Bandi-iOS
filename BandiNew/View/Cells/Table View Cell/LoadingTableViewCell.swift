//
//  LoadingTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/12/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let loadingView = UIActivityIndicatorView()
    
    func setupViews() {
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.startAnimating()
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
