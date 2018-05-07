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
        
        if let navBar = navigationController {
            navBar.navigationBar.prefersLargeTitles = false
        }
        
        title = "Queue"
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.musicTableView.reloadData()
        if TEMPSessionData.queueMusic.count == 0 && (searchBar.text?.isEmpty)! {
            searchBarShownHeight?.isActive = false
            searchBarHiddenHeight?.isActive = true
            self.view.layoutIfNeeded()
        }
        updateSearchResults()
        setCollectionBackground()
    }
    
    var searchBarShownHeight: NSLayoutConstraint?
    var searchBarHiddenHeight: NSLayoutConstraint?
    
    lazy var searchBar: CustomSearchBar = {
        let sb = CustomSearchBar(frame: .zero)
        sb.handleSearchTextChanged = {
            self.updateSearchResults()
        }
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    lazy var musicTableView: QueueMusicTableView = {
        let cv = QueueMusicTableView(frame: .zero)
        cv.musicArray = TEMPSessionData.queueMusic
        cv.handleScroll = { (isUp) -> () in
            if TEMPSessionData.queueMusic.count != 0 {
                self.showSearchBar(show: !isUp)
            }
        }
        cv.handleSwipeStarted = {
            self.showSearchBar(show: false)
        }
        cv.handleMusicRemoved = {
            self.setCollectionBackground()
        }
        cv.isEditing = false
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
        
        musicTableView.reloadData()
    }
    
    func setCollectionBackground() {
        if TEMPSessionData.queueMusic.count == 0 {
            self.musicTableView.showNoQueue()
        } else {
            if (searchBar.text?.isEmpty)! && self.musicTableView.musicArray.count == 0 {
                self.musicTableView.showNoResults()
            } else {
                self.musicTableView.backgroundView = nil
            }
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
        if let text = searchBar.text, !text.isEmpty {
            self.musicTableView.musicArray = TEMPSessionData.queueMusic.filter({ (music) -> Bool in
                return (music.title?.lowercased().contains(text.lowercased()))!
            })
        } else {
            self.musicTableView.musicArray = TEMPSessionData.queueMusic
        }
        setCollectionBackground()
        self.musicTableView.reloadData()
    }
    
}
