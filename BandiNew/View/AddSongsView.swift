//
//  AddSongsView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 8/4/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddSongsView: UIView {
    
    init(buttonText: String, description: String) {
        super.init(frame: .zero)
        button.setTitle(buttonText, for: .normal)
        buttonDescription.text = description
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var handleButtonTapped: (()->())?
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors().primaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.clipsToBounds = false
        return button
    }()
    
    let buttonDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        
        addSubview(button)
        addSubview(buttonDescription)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            
            buttonDescription.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -15),
            buttonDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            buttonDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            buttonDescription.heightAnchor.constraint(equalToConstant: 40),
            buttonDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        handleButtonTapped?()
    }
    
}
