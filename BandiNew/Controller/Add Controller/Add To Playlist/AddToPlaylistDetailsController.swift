//
//  AddToPlaylistDetailsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 8/17/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddToPlaylistDetailsController: PlaylistDetailsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        
        guard let playlist = playlist, let addToPlaylist = SessionData.AddToPlaylist.playlist else { return }
        let songs = playlist.getSongsArray()
        let addToSongs = addToPlaylist.getSongsArray()
        for i in 0..<addToSongs.count {
            let song = addToSongs[i]
            guard let foundSongIndex = songs.index(of: song) else { continue }
            disabledIndexPaths.insert(IndexPath(row: foundSongIndex, section: 1))
        }
        print(disabledIndexPaths)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.prompt = SessionData.AddToPlaylist.songsAddedString
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            guard let songs = playlist?.getSongsArray() else { return }
            let sortedIndexPaths = selectedIndexPaths.sorted(by: <)
            for indexPath in sortedIndexPaths {
                let song = songs[indexPath.row]
                SessionData.AddToPlaylist.songs.append(song)
            }
        }
    }

    private var disabledIndexPaths = Set<IndexPath>()
    private var selectedIndexPaths = Set<IndexPath>()
    private var playlistSelected = false
    
}

// MARK: - Table View Delegate
extension AddToPlaylistDetailsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let playlist = playlist else { return 0 }
        return section == 0 ? 1 : playlist.getSize()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .checkmark
        if let cell = cell as? PlaylistHeaderCell {
            cell.configureSelected(playlistSelected)
            cell.editButton.isHidden = true
            return cell
        }
        if let cell = cell as? QueueMusicTableViewCell {
            let selected = selectedIndexPaths.contains(indexPath)
            cell.configureSelected(selected)
            if disabledIndexPaths.contains(indexPath) {
                cell.setDisabled(disabled: true)
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if disabledIndexPaths.contains(indexPath) { return nil }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playlist = playlist else { return }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            if playlistSelected {
                selectedIndexPaths.removeAll()
            } else {
                var selectedIndexPath = IndexPath(row: 0, section: 1)
                for i in 0..<playlist.getSize() {
                    selectedIndexPath.row = i
                    if !disabledIndexPaths.contains(selectedIndexPath) {
                        selectedIndexPaths.insert(selectedIndexPath)
                    }
                }
            }
            UIView.performWithoutAnimation({
                tableView.reloadData()
            })
            playlistSelected = !playlistSelected
            return
        }
        
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
            UIView.performWithoutAnimation({
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        } else {
            selectedIndexPaths.insert(indexPath)
            UIView.performWithoutAnimation({
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
}
