//
//  AddSongToTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/6/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddSongToTableView: UITableView {
    
    init(song: Song) {
        super.init(frame: .zero, style: .plain)
        
        dataSource = self
        delegate = self
        alwaysBounceVertical = true
        allowsMultipleSelection = true
        tableHeaderView = UIView()
        tableFooterView = UIView()
        register(BaseTableViewCell.self, forCellReuseIdentifier: imageCellId)
        register(PlaylistPreviewTableViewCell.self, forCellReuseIdentifier: playlistCellId)
        
        var indexPath = IndexPath(row: 0, section: 1)
        for i in 0..<playlists.count {
            let playlist = playlists[i]
            if playlist.contains(song: song) {
                indexPath.row = i
                disabledIndexPaths.insert(indexPath)
            }
        }
        if song.saved { disabledIndexPaths.insert(IndexPath(row: 0, section: 0)) }
        
        selectedIndexPaths.insert(IndexPath(row: 0, section: 0))
        reloadData()
        
        setUpTheming()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageCellId = "imageCellId"
    let playlistCellId = "playlistCellId"
    let sideLength = UIScreen.main.bounds.width * 0.25
    var song: Song?
    var librarySelected: ((Bool)->())?
    var addPlaylist: (()->())?
    var scrolled: ((CGFloat)->())?
    private var disabledIndexPaths = Set<IndexPath>()
    private var selectedIndexPaths = Set<IndexPath>()
    private var playlists: [Playlist] {
        return CoreDataHelper.shared.userPlaylists
    }
    private var selectedPlaylists: Set<Playlist> {
        var selected = Set<Playlist>()
        CoreDataHelper.shared.getContext().performAndWait({
            self.selectedIndexPaths.forEach({ indexPath in
                let playlist = playlists[indexPath.row]
                selected.insert(playlist)
            })
        })
        return selected
    }
    
    func getSelectedPlaylists() -> Set<Playlist> {
        return selectedPlaylists
    }
 
}

// MARK: - Table View Data Source
extension AddSongToTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return playlists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selected = selectedIndexPaths.contains(indexPath)
        if indexPath.section == 0 {
            let cell = dequeueReusableCell(withIdentifier: imageCellId, for: indexPath) as! BaseTableViewCell
            if indexPath.row == 0 {
                cell.textLabel?.text = "Library"                
                if disabledIndexPaths.contains(indexPath) {
                    cell.setDisabled(disabled: true)
                    cell.configureSelected(true)
                    return cell
                }
                cell.accessoryType = .checkmark
            } else {
                cell.textLabel?.text = "Add Playlist"
                cell.textLabel?.textColor = Constants.Colors().primaryColor
            }
            cell.configureSelected(selected)
            return cell
        } else {
            let cell = dequeueReusableCell(withIdentifier: playlistCellId, for: indexPath) as! PlaylistPreviewTableViewCell
            cell.playlist = playlists[indexPath.row]
            cell.separatorInset = UIEdgeInsets(top: 0, left: sideLength + 30, bottom: 0, right: 0)
            if disabledIndexPaths.contains(indexPath) {
                cell.setDisabled(disabled: true)
                cell.accessoryType = .none
                return cell
            }
            cell.accessoryType = .checkmark
            cell.configureSelected(selected)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sideLength + 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: - Table View Delegate
extension AddSongToTableView: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom >= height {
            scrolled?(scrollView.contentOffset.y)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if disabledIndexPaths.contains(indexPath) { return nil }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            addPlaylist?()
            return
        }
        if selectedIndexPaths.contains(indexPath) {
            
            if indexPath.section == 0 && indexPath.row == 0 {
                selectedIndexPaths.removeAll()
                UIView.performWithoutAnimation({
                    reloadData()
                })
                librarySelected?(false)
            } else {
                selectedIndexPaths.remove(indexPath)
                UIView.performWithoutAnimation({
                    reloadRows(at: [indexPath], with: .automatic)
                })
            }
            
        } else {
            let library = IndexPath(row: 0, section: 0)
            selectedIndexPaths.insert(indexPath)
            selectedIndexPaths.insert(library)
            UIView.performWithoutAnimation({
                reloadRows(at: [indexPath, library], with: .automatic)
            })
            
            librarySelected?(true)
            
            if indexPath.section == 1 && contentInset.bottom == 55 && indexPath.row == numberOfRows(inSection: 1) - 1 {
                scrollToRow(at: indexPath, at: .none, animated: true)
            }
        }
        
    }
    
}

// MARK: - Theme
extension AddSongToTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.tableBackgroundColor
        separatorColor = theme.tableSeparatorColor
    }
}
