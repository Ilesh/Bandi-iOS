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
        
        title = "Playlists"
        definesPresentationContext = true
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaylist))
        navigationItem.rightBarButtonItem = addBarButton
        navigationItem.searchController = searchController
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.register(AddPlaylistTableViewCell.self, forCellReuseIdentifier: addPlaylistCellId)
        tableView.register(PlaylistPreviewTableViewCell.self, forCellReuseIdentifier: playlistCellId)
        
        setupViews()
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationItem.largeTitleDisplayMode = .always
        guard let nav = navigationController else { return }
        nav.navigationBar.prefersLargeTitles = true
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
    var playlists: [Playlist] {
        return CoreDataHelper.shared.userPlaylists
    }
    
    lazy var searchController: SearchController = {
        let sc = SearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Playlists"
        return sc
    }()
    
    func setupViews() {
        tableView.addSubview(topBorderView)
        topBorderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1)
    }
    
    func filterContentForSearchText(_ searchText: String) {
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPlaylists.count
        }
        return playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: playlistCellId, for: indexPath) as! PlaylistPreviewTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: PlaylistPreviewTableViewCell, at indexPath: IndexPath) {
        let playlist = isFiltering() ? filteredPlaylists[indexPath.row] : playlists[indexPath.row]
        cell.playlist = playlist
        cell.accessoryType = .disclosureIndicator
        let view = UIView(frame: CGRect(x: sideLength + 30, y: cell.frame.height, width: tableView.frame.width, height: 0.5))
        view.backgroundColor = AppThemeProvider.shared.currentTheme.tableSeparatorColor
        cell.addSubview(view)
    }
    
}

// MARK: - Table View Delegate
extension PlaylistsController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sideLength + 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        guard let nav = navigationController else { return }
        let playlistDetailsController = PlaylistDetailsController(style: .plain)
        playlistDetailsController.playlist = playlist
        nav.pushViewController(playlistDetailsController, animated: true)
        searchController.isActive = false
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "DELETE", handler: { (action, view, completion) in
            let playlistDeleteAlert = DeleteAlertController(message: "Are you sure you want to delete this playlist?", actionName: "Delete Playlist")
            playlistDeleteAlert.deletePressed = {
                let playlist = self.playlists[indexPath.row]
                CoreDataHelper.shared.getContext().delete(playlist)
                CoreDataHelper.shared.appDelegate.saveContext()
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }, completion: nil)
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

// MARK: - Theme
extension PlaylistsController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.separatorColor = theme.tableSeparatorColor
        topBorderView.backgroundColor = theme.tableBackgroundColor
    }
}
