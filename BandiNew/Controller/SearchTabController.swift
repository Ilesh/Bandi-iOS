//
//  SearchTabController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import LNPopupController

class SearchTabController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBar = navigationController {
            navBar.navigationBar.prefersLargeTitles = true
        }
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        title = "Search"
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var searchController: SearchController = {
        let sb = SearchController(searchResultsController: nil)
        sb.delegate = self
        sb.searchBar.delegate = self
        sb.searchBar.placeholder = "Search Youtube"
        return sb
    }()
    
    let musicTableView: SearchMusicTableView = {
        let cv = SearchMusicTableView(frame: .zero)
        cv.handleMusicTapped = {
            //self.searchController.searchBar.endEditing(true)
        }
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func setupViews() {
        view.addSubview(musicTableView)
        
        NSLayoutConstraint.activate([
            musicTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            musicTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            musicTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            musicTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateSearchResults), object: nil)
        self.perform(#selector(updateSearchResults), with: nil, afterDelay: 0.5)
    }
    
//    func setCollectionBackground() {
//        if self.musicTableView.musicArray.count == 0 {
//            self.musicTableView.showNoResults()
//        } else {
//            self.musicTableView.backgroundView = nil
//        }
//    }
    
    @objc func updateSearchResults() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if let text = searchController.searchBar.text, !text.isEmpty {
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
            //self.setCollectionBackground()
        }
    }
    
}
