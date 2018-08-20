//
//  AllSongsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AllSongsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "All Songs"
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(QueueMusicTableViewCell.self, forCellReuseIdentifier: songCellId)
        tableView.register(PlaylistControlsTableViewCell.self, forCellReuseIdentifier: controlsCellId)
        
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if let nav = navigationController {
            nav.navigationBar.prefersLargeTitles = true
        }
        if songs.count > 0 {
            navigationItem.searchController = searchController
            tableView.backgroundView = nil
            tableView.alwaysBounceVertical = true
        } else {
            navigationItem.searchController = nil
            tableView.backgroundView = backgroundView
            tableView.alwaysBounceVertical = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppThemeProvider.shared.currentTheme.statusBarStyle
    }
    
    let controlsCellId = "controlsCellId"
    let songCellId = "songCellId"
    var filteredSongs: [Song] = []
    
    var songs: [Song] {
        get {
            return CoreDataHelper.shared.allSongs
        }
        set { }
    }
    
    let backgroundView = AddSongsView(buttonText: "FIND MUSIC", description: "Looks like you don't have any music saved")
    
    lazy var searchController: SearchController = {
        let sc = SearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Songs"
        return sc
    }()
    
    private var persistentContainer = CoreDataHelper.shared.getPersistentContainer()
    private lazy var context = CoreDataHelper.shared.getContext()

    
    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredSongs = songs.filter({ (song: Song) -> Bool in
            if !searchBarIsEmpty {
                return song.title!.lowercased().contains(searchText.lowercased())
            } else {
                return true
            }
        })
        tableView.reloadData()
    }
    
}

// MARK: - Search Bar Delegate
extension AllSongsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
}

// MARK: - Search Results Updating
extension AllSongsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}

// MARK: - Table View Data Source
extension AllSongsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredSongs.count
        }
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: songCellId, for: indexPath) as! QueueMusicTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: controlsCellId) as! PlaylistControlsTableViewCell
        cell.play = {
            UpNextWrapper.shared.setUpNextSongs(songs: self.songs)
            UpNextWrapper.shared.setCurrentlyPlayingIndex(index: 0)
        }
        cell.shuffle = {
            var playlistSongs = self.songs
            playlistSongs.shuffle()
            UpNextWrapper.shared.setUpNextSongs(songs: playlistSongs)
            UpNextWrapper.shared.setCurrentlyPlayingIndex(index: 0)
        }
        let view = UIView(frame: CGRect(x: 15, y: 74, width: tableView.frame.width, height: 0.5))
        view.backgroundColor = AppThemeProvider.shared.currentTheme.tableSeparatorColor
        cell.addSubview(view)
        return cell
    }
    
    func configure(_ cell: QueueMusicTableViewCell, at indexPath: IndexPath) {
        let song = isFiltering ? filteredSongs[indexPath.row] : songs[indexPath.row]
        cell.music = song
        let view = UIView(frame: CGRect(x: 90, y: cell.frame.height, width: tableView.frame.width, height: 0.5))
        view.backgroundColor = AppThemeProvider.shared.currentTheme.tableSeparatorColor
        cell.addSubview(view)
    }
    
}

// MARK: - Table View Delegate
extension AllSongsController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if songs.count == 0 {
            return 0
        }
        return 74
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UpNextWrapper.shared.setUpNextSongs(songs: songs)
        UpNextWrapper.shared.setCurrentlyPlayingIndex(index: indexPath.row)
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let song = songs[indexPath.row]
        
        let queue = UIContextualAction(style: .normal, title: "QUEUE", handler: { (action, view, completion) in
            CoreDataHelper.shared.queue?.insertSongAtEnd(song: song)
            song.setSaved(saved: false, retain: true)
            completion(true)
        })
        queue.backgroundColor = Constants.Colors().secondaryColor
        
        let add = UIContextualAction(style: .normal, title: "ADD", handler: { (action, view, completion) in
            guard let nav = self.navigationController else { return }
            let addSongController = AddController()
            addSongController.song = song
            let addSongNav = CustomNavigationController(rootViewController: addSongController)
            nav.present(addSongNav, animated: true, completion: nil)
            completion(true)
        })
        add.backgroundColor = Constants.Colors().primaryColor
        
        let delete = UIContextualAction(style: .normal, title: "DELETE", handler: { (action, view, completion) in
            let songDeleteAlert = DeleteAlertController(message: "Deleting a song also removes it from all playlists", actionName: "Delete Song")
            songDeleteAlert.deletePressed = {
                let playlists = CoreDataHelper.shared.userPlaylists
                CoreDataHelper.shared.getContext().performAndWait {
                    song.setSaved(saved: false, retain: false)
                    for playlist in playlists {
                        playlist.removeSong(song: song)
                    }
                    CoreDataHelper.shared.appDelegate.saveContext()
                }
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: [indexPath], with: .left)
                }, completion: nil)
            }
            songDeleteAlert.willDisappear = {
                completion(true)
            }
            self.present(songDeleteAlert, animated: true, completion: nil)
        })
        delete.backgroundColor = .red
        
        let config = UISwipeActionsConfiguration(actions: [delete, queue, add])
        
        return config
    }
    
    @objc func addPlaylist() {
        guard let nav = navigationController else { return }
        let addPlaylistController = AddPlaylistController(style: .plain)
        let addPlaylistNav = CustomNavigationController(rootViewController: addPlaylistController)
        nav.present(addPlaylistNav, animated: true, completion: nil)
    }
    
}

// MARK: - Theme
extension AllSongsController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.separatorColor = theme.tableSeparatorColor
    }
}
