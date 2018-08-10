//
//  AddPlaylistController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/1/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddPlaylistController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBar = navigationController {
            navBar.navigationBar.prefersLargeTitles = false
        }
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = cancelBarButton
        
        title = "Add Playlist"
        
        tableView.tableFooterView = UIView()
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: addPlaylistCellId)
        setUpTheming()
    }
    
    let addPlaylistCellId = "addPlaylistCellId"
    let cellTitles = ["Create Playlist", "Import Bandi Playlist","Import YouTube Playlist"]
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Table View Data Source
extension AddPlaylistController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addPlaylistCellId, for: indexPath) as! BaseTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: BaseTableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.text = cellTitles[indexPath.row]
    }
    
}

// MARK: - Table View Delegate
extension AddPlaylistController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let nav = navigationController else { return }
            let createPlaylistController = CreatePlaylistController(style: .plain)
            nav.pushViewController(createPlaylistController, animated: true)
        }
        else if indexPath.row == 2 {
            guard let nav = navigationController else { return }
            let importYoutubeIntermediaryController = ImportYoutubeIntermediaryController()
            nav.pushViewController(importYoutubeIntermediaryController, animated: true)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
}

// MARK: - Theme
extension AddPlaylistController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.separatorColor = theme.tableSeparatorColor
    }
}
