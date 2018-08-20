//
//  AddToPlaylistAllSongsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 8/17/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddToPlaylistAllSongsController: AllSongsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNav), name: .addToPlaylistSongsNumberChanged, object: nil)
        
        guard let addToPlaylist = SessionData.addToPlaylist.playlist else { return }
        let addToSongs = addToPlaylist.getSongsArray()
        for i in 0..<songs.count {
            let song = songs[i]
            let currentIndexPath = IndexPath(row: i, section: 0)
            if addToSongs.contains(song) { disabledIndexPaths.insert(currentIndexPath) }
            if SessionData.addToPlaylist.songs.contains(song) { selectedIndexPaths.insert(currentIndexPath) }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = navigationController {
            nav.navigationBar.prefersLargeTitles = false
        }
        navigationItem.largeTitleDisplayMode = .never
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
    
    func updateAddToSession() {
        var currentIndexPath = IndexPath(row: 0, section: 0)
        for i in 0..<songs.count {
            currentIndexPath.row = i
            let song = songs[i]
            
            if selectedIndexPaths.contains(currentIndexPath) && !SessionData.addToPlaylist.songs.contains(song) {
                
                SessionData.addToPlaylist.songs.append(song)
                print(SessionData.addToPlaylist.songs)
                
            } else if !disabledIndexPaths.contains(currentIndexPath)
                && !selectedIndexPaths.contains(currentIndexPath)
                && SessionData.addToPlaylist.songs.contains(song) {
                
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
extension AddToPlaylistAllSongsController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! QueueMusicTableViewCell
        cell.accessoryType = .checkmark
        let selected = selectedIndexPaths.contains(indexPath)
        cell.configureSelected(selected)
        if disabledIndexPaths.contains(indexPath) {
            cell.setDisabled(disabled: true)
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if disabledIndexPaths.contains(indexPath) { return nil }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            SessionData.addToPlaylist.updateProposedAdds(updateBy: -1)
            selectedIndexPaths.remove(indexPath)
            UIView.performWithoutAnimation({
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        } else {
            SessionData.addToPlaylist.updateProposedAdds(updateBy: 1)
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
