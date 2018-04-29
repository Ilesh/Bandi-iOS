//
//  QueueTabController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueTabController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.musicCollectionView.musicArray = TEMPSessionData.queueMusic
        self.musicCollectionView.reloadData()
    }
    
    lazy var searchBar: CustomSearchBar = {
        let sb = CustomSearchBar(frame: .zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.handleSearchTextChanged = {
            self.updateSearchResults()
        }
        return sb
    }()
    
    lazy var musicCollectionView: QueueMusicCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = QueueMusicCollectionView(frame: view.frame, collectionViewLayout: layout)
        cv.musicArray = TEMPSessionData.queueMusic
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
        if let text = searchBar.text, !text.isEmpty {
            self.musicCollectionView.musicArray = TEMPSessionData.queueMusic.filter({ (music) -> Bool in
                return (music.title?.lowercased().contains(text.lowercased()))!
            })
        } else {
            self.musicCollectionView.musicArray = TEMPSessionData.queueMusic
        }
        self.musicCollectionView.reloadData()
    }
    
}
