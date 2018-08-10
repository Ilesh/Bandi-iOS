//
//  CreatePlaylistHeaderTableViewCell.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class CreatePlaylistHeaderTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let playlistSideLength = UIScreen.main.bounds.width * 0.373
    var playlistNameUpdated: ((String)->())?
    
    private lazy var playlistImageContainer: PlaylistBaseArtView = {
        let view = PlaylistBaseArtView(gradientFrame: CGRect(x: 0, y: 0, width: self.playlistSideLength, height: self.playlistSideLength))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    func getPlaylistTitle() -> String {
        var playlistTitle = titleField.text
        if playlistTitle == "" {
            playlistTitle = "Untitled"
        }
        return playlistTitle!
    }
    
    func setPlaylistTitle(title: String) {
        titleField.text = title
    }
    
    func setup() {
        addSubview(playlistImageContainer)
        addSubview(titleField)
        
        NSLayoutConstraint.activate([
            playlistImageContainer.widthAnchor.constraint(equalToConstant: playlistSideLength),
            playlistImageContainer.heightAnchor.constraint(equalToConstant: playlistSideLength),
            playlistImageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            playlistImageContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleField.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleField.leadingAnchor.constraint(equalTo: playlistImageContainer.trailingAnchor, constant: 15),
            titleField.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleField.heightAnchor.constraint(equalToConstant: 15),
            ])
        
        titleField.sizeToFit()
    }
    
    override func applyTheme(_ theme: AppTheme) {
        super.applyTheme(theme)
        titleField.textColor = theme.textColor
        titleField.attributedPlaceholder = NSAttributedString(string: "Untitled", attributes: [NSAttributedStringKey.foregroundColor : theme.subTextColor])
    }
    
}

// MARK: - Text Field Delegate
extension CreatePlaylistHeaderTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        playlistNameUpdated?(getPlaylistTitle())
    }
    
}
