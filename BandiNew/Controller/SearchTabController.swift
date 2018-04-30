//
//  SearchTabController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchTabController: UIViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    lazy var searchBar: PlatformSearchView = {
        let sb = PlatformSearchView()
        sb.handleDelayedSearchTextChanged = {
            self.updateSearchResults()
        }
        sb.searchBar.tintColor = Constants.Colors().primaryColor
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    lazy var musicCollectionView: SearchMusicCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = SearchMusicCollectionView(frame: view.frame, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(musicCollectionView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            musicCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            musicCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            musicCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            musicCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
    }
    
    func updateSearchResults() {
        if let text = searchBar.searchBar.text, !text.isEmpty {
            MusicFetcher.fetchYoutube(apiKey: APIKeys.init().youtubeKey, keywords: text) { (youtubeVideos) -> Void in
                if let youtubeVideos = youtubeVideos {
                    DispatchQueue.main.async {
                        self.musicCollectionView.musicArray = youtubeVideos
                        DispatchQueue.main.async {
                            self.musicCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}
