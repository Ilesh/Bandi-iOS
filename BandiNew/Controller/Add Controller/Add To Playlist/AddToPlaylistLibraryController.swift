//
//  AddToPlaylistLibraryController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 8/17/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddToPlaylistLibraryController: LibraryTabController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.prompt = SessionData.AddToPlaylist.songsAddedString
        navigationItem.largeTitleDisplayMode = .never
        if let navBar = navigationController {
            navBar.navigationBar.prefersLargeTitles = true
        }
    }
    
    lazy var searchController: SearchController = {
        let sc = SearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Library"
        return sc
    }()
    
    @objc func done() {
        
    }
    
}

// MARK: - Search Bar Delegate
extension AddToPlaylistLibraryController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
}

// MARK: - Search Results Updating
extension AddToPlaylistLibraryController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

// MARK: - Table View Delegate
extension AddToPlaylistLibraryController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let navController = navigationController else { return }
            let playlistsController = AddToPlaylistListController(style: .grouped)
            playlistsController.navigationItem.prompt = SessionData.AddToPlaylist.songsAddedString
            navController.pushViewController(playlistsController, animated: true)
        }
        else if indexPath.row == 1 {
            guard let navController = navigationController else { return }
            let allSongsController = AllSongsController(style: .grouped)
            navController.pushViewController(allSongsController, animated: true)
        }
        else if indexPath.row == 2 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBar = appDelegate.mainTabBarController
            tabBar.selectedIndex = 2
        }
    }
    
}

