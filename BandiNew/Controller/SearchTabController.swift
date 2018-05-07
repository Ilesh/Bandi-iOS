//
//  SearchTabController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import LNPopupController

class SearchTabController: UIViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var searchBarShownHeight: NSLayoutConstraint?
    var searchBarHiddenHeight: NSLayoutConstraint?
    
    lazy var searchBar: PlatformSearchView = {
        let sb = PlatformSearchView()
        sb.handleDelayedSearchTextChanged = {
            self.updateSearchResults()
        }
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    lazy var musicTableView: SearchMusicTableView = {
        let cv = SearchMusicTableView(frame: .zero)
        cv.handleScroll = { (isUp) -> () in
            self.showSearchBar(show: !isUp)
        }
        cv.handleSwipeStarted = {
            self.showSearchBar(show: false)
        }
        cv.handleMusicTapped = {
            self.searchBar.searchBar.endEditing(true)
        }
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(musicTableView)
        
        searchBarShownHeight = searchBar.heightAnchor.constraint(equalToConstant: 50)
        searchBarShownHeight = searchBar.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            musicTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            musicTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            musicTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            musicTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
    }
    
    func setCollectionBackground() {
        if self.musicTableView.musicArray.count == 0 {
            self.musicTableView.showNoResults()
        } else {
            self.musicTableView.backgroundView = nil
        }
    }
    
    func showSearchBar(show: Bool) {
        self.searchBar.endEditing(!show)
        searchBarShownHeight?.isActive = show
        searchBarHiddenHeight?.isActive = !show
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func updateSearchResults() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if let text = searchBar.searchBar.text, !text.isEmpty {
            MusicFetcher.fetchYoutube(apiKey: APIKeys.init().youtubeKey, keywords: text) { (youtubeVideos) -> Void in
                DispatchQueue.main.async {
                    self.musicTableView.showLoading()
                }
                if let youtubeVideos = youtubeVideos {
                    DispatchQueue.main.async {
                        self.musicTableView.musicArray = youtubeVideos
                        DispatchQueue.main.async {
                            self.musicTableView.reloadData()
                            dispatchGroup.leave()
                        }
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.setCollectionBackground()
        }
    }
    
}
