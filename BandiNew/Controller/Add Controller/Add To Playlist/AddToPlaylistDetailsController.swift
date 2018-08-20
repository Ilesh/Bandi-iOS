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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNav), name: .addToPlaylistSongsNumberChanged, object: nil)
        
        guard let playlist = playlist, let addToPlaylist = SessionData.addToPlaylist.playlist else { return }
        let songs = playlist.getSongsArray()
        let addToSongs = addToPlaylist.getSongsArray()
        for i in 0..<songs.count {
            let song = songs[i]
            let currentIndexPath = IndexPath(row: i, section: 1)
            if addToSongs.contains(song) { disabledIndexPaths.insert(currentIndexPath) }
            if SessionData.addToPlaylist.songs.contains(song) { selectedIndexPaths.insert(currentIndexPath) }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNav()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController { updateAddToSession() }
        if donePressed {
            updateAddToSession()
            SessionData.addToPlaylist.addSongsToPlaylist()
        }
    }
    
    private var donePressed = false
    private var disabledIndexPaths = Set<IndexPath>()
    private var selectedIndexPaths = Set<IndexPath>()
    private var playlistSelected: Bool {
        guard let playlist = playlist else { return false }
        let availableSelectable = playlist.getSize() - disabledIndexPaths.count
        return availableSelectable == selectedIndexPaths.count
    }
    private var headerDisabled: Bool {
        return disabledIndexPaths.count == playlist?.getSize()
    }
    
    func updateAddToSession() {
        guard let playlist = playlist else { return }
        let songs = playlist.getSongsArray()
        var currentIndexPath = IndexPath(row: 0, section: 1)
        for i in 0..<playlist.getSize() {
            
            currentIndexPath.row = i
            let song = songs[i]
            let playlistAlreadyContains = SessionData.addToPlaylist.songs.contains(song)
            if selectedIndexPaths.contains(currentIndexPath) && !playlistAlreadyContains {
                
                SessionData.addToPlaylist.songs.append(song)
                
            } else if !disabledIndexPaths.contains(currentIndexPath)
                && !selectedIndexPaths.contains(currentIndexPath)
                && playlistAlreadyContains {
                
                guard let index = SessionData.addToPlaylist.songs.index(of: song) else { continue }
                SessionData.addToPlaylist.songs.remove(at: index)
                
            }
            
        }
        
        SessionData.addToPlaylist.setProposedAdds(adds: 0)
    }
    
    @objc func updateNav() {
        navigationItem.prompt = SessionData.addToPlaylist.songsAddedString
        navigationItem.rightBarButtonItem?.isEnabled =  SessionData.addToPlaylist.getProposedAdds() > 0 || SessionData.addToPlaylist.songs.count > 0
    }
    
    @objc func done() {
        donePressed = true
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Table View Delegate
extension AddToPlaylistDetailsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let playlist = playlist else { return 0 }
        return section == 0 ? 1 : playlist.getSize()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cell = cell as? PlaylistHeaderCell {
            cell.editButton.isHidden = true
            cell.configureSelected(playlistSelected)
            cell.setDisabled(disabled: headerDisabled)
            if !headerDisabled {
                cell.accessoryType = .checkmark
            }
            return cell
        }
        if let cell = cell as? QueueMusicTableViewCell {
            cell.accessoryType = .checkmark
            let selected = selectedIndexPaths.contains(indexPath)
            cell.configureSelected(selected)
            if disabledIndexPaths.contains(indexPath) {
                cell.setDisabled(disabled: true)
                cell.configureSelected(false)
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if disabledIndexPaths.contains(indexPath) { return nil }
        else if indexPath.section == 0 && headerDisabled { return nil }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playlist = playlist else { return }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let previousSelectedCount = selectedIndexPaths.count
            if playlistSelected {
                SessionData.addToPlaylist.updateProposedAdds(updateBy: -previousSelectedCount)
                selectedIndexPaths.removeAll()
            } else {
                var selectedIndexPath = IndexPath(row: 0, section: 1)
                for i in 0..<playlist.getSize() {
                    selectedIndexPath.row = i
                    if !disabledIndexPaths.contains(selectedIndexPath) {
                        selectedIndexPaths.insert(selectedIndexPath)
                    }
                }
                let finalSelectedCount = selectedIndexPaths.count
                SessionData.addToPlaylist.updateProposedAdds(updateBy: finalSelectedCount - previousSelectedCount)
            }
            UIView.performWithoutAnimation({
                tableView.reloadData()
            })
            return
        }
        
        if selectedIndexPaths.contains(indexPath) {
            SessionData.addToPlaylist.updateProposedAdds(updateBy: -1)
            selectedIndexPaths.remove(indexPath)
            UIView.performWithoutAnimation({
                tableView.reloadRows(at: [indexPath, IndexPath(row: 0, section: 0)], with: .automatic)
            })
        } else {
            SessionData.addToPlaylist.updateProposedAdds(updateBy: 1)
            selectedIndexPaths.insert(indexPath)
            UIView.performWithoutAnimation({
                tableView.reloadRows(at: [indexPath, IndexPath(row: 0, section: 0)], with: .automatic)
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
