//
//  AddToPlaylistListController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 8/17/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddToPlaylistListController: PlaylistsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.prompt = SessionData.AddToPlaylist.songsAddedString
        navigationItem.largeTitleDisplayMode = .never
        guard let nav = navigationController else { return }
        nav.navigationBar.prefersLargeTitles = false
    }
    
    var disabledIndexPath = IndexPath()
    override var playlists: [Playlist] {
        var playlists = CoreDataHelper.shared.userPlaylists
        for i in 0..<playlists.count {
            if playlists[i] == SessionData.AddToPlaylist.playlist {
                disabledIndexPath = IndexPath(row: i, section: 0)
                break
            }
        }
        return playlists
    }
    
}

// MARK: Table View Delegate
extension AddToPlaylistListController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! PlaylistPreviewTableViewCell
        if indexPath == disabledIndexPath {
            cell.setDisabled(disabled: true)
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == disabledIndexPath { return nil }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        guard let nav = navigationController else { return }
        let playlistDetailsController = AddToPlaylistDetailsController(style: .plain)
        playlistDetailsController.playlist = playlist
        nav.pushViewController(playlistDetailsController, animated: true)
        searchController.isActive = false
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
}
