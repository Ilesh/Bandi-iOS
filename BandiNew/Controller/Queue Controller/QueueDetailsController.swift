//
//  QueueDetailsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueDetailsController: PlaylistDetailsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(title: "Theme", style: .plain, target: self, action: #selector(themeTapped))
        navigationItem.leftBarButtonItem = barButton
        
        tableView.register(QueueHeaderViewCell.self, forCellReuseIdentifier: detailsCellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var playlist: Playlist? {
        get {
            return CoreDataHelper.shared.queue
        }
        set { }
    }
    
    let queueEditAlert = QueueEditAlertController()
    
    override func createDetailHeaderCell(indexPath: IndexPath) -> PlaylistHeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellId, for: indexPath) as! QueueHeaderViewCell
        cell.editButtonTapped = {
            self.present(self.queueEditAlert, animated: true, completion: nil)
        }
        cell.playlist = playlist
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        return cell
    }
    
    @objc func themeTapped() {
        AppThemeProvider.shared.nextTheme()
        let themeName = AppThemeProvider.shared.currentTheme.themeName
        UserDefaults.standard.setSavedTheme(value: themeName)
    }
    
}
