//
//  SearchYoutubeController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchYoutubeController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = navigationController {
            nav.extendedLayoutIncludesOpaqueBars = true
        }
        
        navigationItem.searchController = searchController
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        title = "Search"
        
        definesPresentationContext = true
        
        tableView = recentSearchesTableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        guard let navBar = navigationController else { return }
        navBar.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppThemeProvider.shared.currentTheme.statusBarStyle
    }
    
    var previousSearch = ""
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    lazy var searchController: SearchController = {
        let sc = SearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Youtube"
        return sc
    }()
    
    lazy var recentSearchesTableView: RecentSearchesTableView = {
        let tv = RecentSearchesTableView(frame: .zero, style: .grouped)
        tv.rowSelected = { searchString in
            self.searchController.searchBar.text = searchString
            self.searchController.searchBar.endEditing(true)
            self.updateYoutubeResults()
            self.toggleSearchActive(true)
            self.tableView = self.musicTableView
        }
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var suggestionsTableView: SearchSuggestionsTableView = {
        let tv = SearchSuggestionsTableView()
        tv.suggestionSelected = { suggestion in
            self.searchController.searchBar.text = suggestion
            self.searchController.searchBar.endEditing(true)
            self.tableView = self.musicTableView
            self.updateYoutubeResults()
        }
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var musicTableView: SearchMusicTableView = {
        let tv = SearchMusicTableView(frame: .zero, style: .grouped)
        tv.addSong = { song in
            guard let nav = self.navigationController else { return }
            let addSongController = AddController()
            addSongController.song = song
            let addSongNav = CustomNavigationController(rootViewController: addSongController)
            nav.present(addSongNav, animated: true, completion: nil)
        }
        tv.handleMusicTapped = { song in
            self.searchController.searchBar.endEditing(true)
            let context = CoreDataHelper.shared.getContext()
            context.perform {
                song.setSaved(saved: false, retain: true)
                UpNextWrapper.shared.setUpNextSongs(songs: [song])
                UpNextWrapper.shared.setCurrentlyPlayingIndex(index: 0)
            }
        }
        tv.handleScroll = { isUp in
            self.searchController.searchBar.endEditing(true)
        }
        tv.bottomReached = {
            DispatchQueue.global(qos: .userInitiated).async {
                MusicFetcher.shared.fetchYoutubeNextPage(handler: { (youtubeVideos) -> Void in
                    guard let youtubeVideos = youtubeVideos else { return }
                    let filteredVideos = youtubeVideos.filter({ song in
                        let videos = self.musicTableView.musicArray
                        // same song can repeat b/c different entity, thats why check video id
                        for video in videos {
                            if video.id == song.id { return false }
                        }
                        return true
                    })
                    self.musicTableView.musicArray = self.musicTableView.musicArray + filteredVideos
                    DispatchQueue.main.async {
                        self.musicTableView.reloadData()
                    }
                })
            }
        }
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func updateYoutubeResults() {
        
        self.musicTableView.scrollToFirstRow(animated: false)
        
        let searchBarText = self.searchController.searchBar.text!
        guard previousSearch != searchBarText else { return }
        previousSearch = searchBarText
        
        self.musicTableView.musicArray.removeAll()
        self.musicTableView.isSearching = true
        self.musicTableView.reloadData()
        DispatchQueue.global(qos: .userInitiated).async {
            MusicFetcher.shared.fetchYoutube(keywords: searchBarText) { (youtubeVideos) -> Void in
                guard let youtubeVideos = youtubeVideos else { return }
                self.musicTableView.musicArray = youtubeVideos
                self.musicTableView.isSearching = false
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            }
        }
        
        CoreDataHelper.shared.addRecentSearch(searchString: searchBarText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if !searchText.isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                MusicFetcher.shared.fetchYoutubeAutocomplete(searchQuery: searchText, handler: { suggestions in
                    DispatchQueue.main.async {
                        self.suggestionsTableView.suggestions = suggestions
                        self.suggestionsTableView.reloadData()
                    }
                })
            }
        }
        tableView.reloadData()
    }
    
    func toggleSearchActive(_ isActive: Bool) {
        self.searchController.isActive = isActive
    }
    
}

// MARK: - Search Controller Delegate
extension SearchYoutubeController: UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.definesPresentationContext = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print(tableView is MusicTableView)
//        if tableView is MusicTableView {
//            definesPresentationContext = true
//        } else {
//            definesPresentationContext = false
//        }
    }
    
}


// MARK: - Search Bar Delegate
extension SearchYoutubeController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateYoutubeResults()
        tableView = musicTableView
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView = recentSearchesTableView
        toggleSearchActive(false)
    }
    
}

// MARK: - Search Results Updating
extension SearchYoutubeController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
        if searchController.isActive {
            if searchBarIsEmpty() {
                tableView = recentSearchesTableView
            } else {
                tableView = suggestionsTableView
            }
        }
    }
    
}
