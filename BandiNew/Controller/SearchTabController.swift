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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var searchBar: CustomSearchBar = {
        let sb = CustomSearchBar(frame: .zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.connectedVideoCollectionView = musicCollectionView
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
    
}
