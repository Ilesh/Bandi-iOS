//
//  ImportYoutubeIntermediaryController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 8/1/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class ImportYoutubeIntermediaryController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YouTube Playlist"
        
        setupViews()
        setUpTheming()
    }
    
    lazy var playlistIdInput: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        return tf
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors().primaryColor
        button.titleLabel?.textColor = .white
        button.titleLabel?.text = "DONE"
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.clipsToBounds = false
        return button
    }()
    
    func setupViews() {
        
        view.addSubview(playlistIdInput)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            playlistIdInput.heightAnchor.constraint(equalToConstant: 20),
            playlistIdInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            playlistIdInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            playlistIdInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playlistIdInput.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            doneButton.topAnchor.constraint(equalTo: playlistIdInput.bottomAnchor, constant: 20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        
        doneButton.addTarget(self, action: #selector(tryYoutubeUrl), for: .touchUpInside)
        
    }
    
    @objc func tryYoutubeUrl() {
        guard let youtubeUrlText = playlistIdInput.text, let nav = navigationController else { return }
        let importYoutubePlaylistController = ImportYoutubePlaylistController(playlistId: youtubeUrlText)
        nav.pushViewController(importYoutubePlaylistController, animated: true)
    }
    
}

// MARK: - Text Field Delegate
extension ImportYoutubeIntermediaryController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    
}

// MARK: Themed
extension ImportYoutubeIntermediaryController: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.tableBackgroundColor
        playlistIdInput.textColor = theme.textColor
        playlistIdInput.attributedPlaceholder = NSAttributedString(string: "Paste a Youtube playlist URL", attributes: [NSAttributedStringKey.foregroundColor : theme.subTextColor])
    }
}
