//
//  AllSongsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class AllSongsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        definesPresentationContext = true
        
        title = "All Songs"
        
        tableView.tableFooterView = UIView()
        tableView.register(QueueMusicTableViewCell.self, forCellReuseIdentifier: songCellId)
        tableView.register(PlaylistControlsTableViewCell.self, forCellReuseIdentifier: controlsCellId)
        
        navigationItem.searchController = searchController
        
        setUpTheming()
        fetchSongs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            guard let fetchedSongs = fetchedResultsController.fetchedObjects else { return [] }
            return fetchedSongs
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
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Song> = {
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        let alphabeticalSort = NSSortDescriptor(key: "title", ascending: true)
        let isSaved = NSPredicate(format: "%K == %@", "saved", NSNumber(value: true))
        fetchRequest.sortDescriptors = [alphabeticalSort]
        fetchRequest.predicate = isSaved

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private func fetchSongs() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error: \(error)")
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredSongs = songs.filter({ (song: Song) -> Bool in
            if !searchBarIsEmpty() {
                return song.title!.lowercased().contains(searchText.lowercased())
            } else {
                return true
            }
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
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
        if isFiltering() {
            return filteredSongs.count
        }
        guard let fetchedSongs = fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedSongs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: songCellId, for: indexPath) as! QueueMusicTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: controlsCellId) as! PlaylistControlsTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
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
        return cell
    }
    
    func configure(_ cell: QueueMusicTableViewCell, at indexPath: IndexPath) {
        let song = isFiltering() ? filteredSongs[indexPath.row] : songs[indexPath.row]
        cell.music = song
        cell.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
    }
    
}

// MARK: - Table View Delegate
extension AllSongsController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if songs.count == 0 {
            return 0
        }
        return 74
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
            let songDeleteAlert = SongDeleteAlertController()
            songDeleteAlert.deletePressed = {
                let context = CoreDataHelper.shared.getContext()
                
                
                let playlistFetchedResultsController: NSFetchedResultsController<Playlist> = {
                    let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
                    let onlyUserPlaylists = NSPredicate(format: "%K == %@", "orderRank", "0")
                    let onlySavedPlaylists = NSPredicate(format: "%K == %@", "saved", NSNumber(value: true))
                    let predicate = NSCompoundPredicate(type: .and, subpredicates: [onlyUserPlaylists, onlySavedPlaylists])
                    fetchRequest.sortDescriptors = []
                    fetchRequest.predicate = predicate
                    
                    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                              managedObjectContext: context,
                                                                              sectionNameKeyPath: nil,
                                                                              cacheName: nil)
                    return fetchedResultsController
                }()
                
                do {
                    try playlistFetchedResultsController.performFetch()
                } catch {
                    print(error)
                }
                
                
                guard let playlists = playlistFetchedResultsController.fetchedObjects else { return }
                context.performAndWait {
                    print("here")
                    song.setSaved(saved: false, retain: false)
                    for playlist in playlists {
                        playlist.removeSong(song: song)
                    }
                    CoreDataHelper.shared.appDelegate.saveContext()
                }
                
//                do {
//                    try playlistFetchedResultsController.performFetch()
//                } catch {
//                    print(error)
//                }
//
//                self.songs.remove(at: indexPath.row)
//
//                tableView.deleteRows(at: [indexPath], with: .left)
//                //tableView.reloadData()
                
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

// MARK: - Fetched Results Controller Delegate
extension AllSongsController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? QueueMusicTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }

}

// MARK: - Theme
extension AllSongsController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.separatorColor = theme.tableSeparatorColor
    }
}
