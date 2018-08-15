//
//  PlaylistsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/1/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class PlaylistsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaylist))
        navigationItem.rightBarButtonItem = addBarButton
        navigationItem.searchController = searchController
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        view.backgroundColor = .green
        
        title = "Playlists"
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: sideLength + 30, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = .yellow
        tableView.allowsSelection = true
        tableView.register(AddPlaylistTableViewCell.self, forCellReuseIdentifier: addPlaylistCellId)
        tableView.register(PlaylistPreviewTableViewCell.self, forCellReuseIdentifier: playlistCellId)
        
        setupViews()
        setUpTheming()
        fetchPlaylists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPlaylists()
        tableView.reloadData()
        if let navBar = navigationController {
            navBar.navigationBar.prefersLargeTitles = true
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
    
    let sideLength = UIScreen.main.bounds.width * 0.25
    private let topBorderView = UIView()
    private let bottomBorderView = UIView()
    private let addPlaylistCellId = "addPlaylistCellId"
    private let playlistCellId = "playlistCellId"
    var filteredPlaylists: [Playlist] = []
    
    lazy var searchController: SearchController = {
        let sc = SearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Playlists"
        return sc
    }()
    
    private lazy var context = CoreDataHelper.shared.getContext()
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Playlist> = {
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
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private func fetchPlaylists() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error: \(error)")
        }
    }
    
    func setupViews() {
        tableView.addSubview(topBorderView)
        tableView.addSubview(bottomBorderView)
        bottomBorderView.backgroundColor = .red
        topBorderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        guard let playlists = fetchedResultsController.fetchedObjects else { return }
        filteredPlaylists = playlists.filter({ (playlist: Playlist) -> Bool in
            if !searchBarIsEmpty() {
                return playlist.title!.lowercased().contains(searchText.lowercased())
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
extension PlaylistsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
}

// MARK: - Search Results Updating
extension PlaylistsController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}

// MARK: - Table View Data Source
extension PlaylistsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPlaylists.count
        }
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: playlistCellId, for: indexPath) as! PlaylistPreviewTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: PlaylistPreviewTableViewCell, at indexPath: IndexPath) {
        let playlist = isFiltering() ? filteredPlaylists[indexPath.row] : fetchedResultsController.object(at: indexPath)
        cell.playlist = playlist
        cell.accessoryType = .disclosureIndicator
    }
    
}

// MARK: - Table View Delegate
extension PlaylistsController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sideLength + 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0//60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fetchedPlaylist = fetchedResultsController.object(at: indexPath)
        guard let nav = navigationController else { return }
        let playlistDetailsController = PlaylistDetailsController(style: .plain)
        playlistDetailsController.playlist = fetchedPlaylist
        nav.pushViewController(playlistDetailsController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "REMOVE", handler: { (action, view, completion) in
            let playlistDeleteAlert = DeleteAlertController(message: "Are you sure you want to delete this playlist?", actionName: "Delete Playlist")
            playlistDeleteAlert.deletePressed = {
                let playlist = self.fetchedResultsController.object(at: indexPath)
                self.context.delete(playlist)
                CoreDataHelper.shared.appDelegate.saveContext()
                tableView.reloadData()
            }
            playlistDeleteAlert.willDisappear = {
                completion(true)
            }
            self.present(playlistDeleteAlert, animated: true, completion: nil)
        })
        delete.backgroundColor = .red
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        
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
extension PlaylistsController: NSFetchedResultsControllerDelegate {
    
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? PlaylistPreviewTableViewCell {
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
extension PlaylistsController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.separatorColor = theme.tableSeparatorColor
        topBorderView.backgroundColor = theme.tableBackgroundColor
    }
}
