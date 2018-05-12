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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
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
        sb.hidesNavigationBarDuringPresentation = true
        sb.searchBar.placeholder = "Search Youtube"
        sb.dimsBackgroundDuringPresentation = false
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
    
    lazy var suggestionsTableView: SearchSuggestionsTableView = {
        let tv = SearchSuggestionsTableView(frame: .zero)
        tv.suggestionSelected = { suggestion in
            self.searchController.searchBar.text = suggestion
            self.searchController.searchBar.endEditing(true)
            self.updateSearchResults()
        }
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupViews() {
        view.addSubview(musicTableView)
        view.addSubview(suggestionsTableView)
        
        NSLayoutConstraint.activate([
            suggestionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            suggestionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            suggestionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            musicTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            musicTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            musicTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            musicTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            suggestionsTableView.contentInset.bottom = keyboardSize.height
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateSearchSuggestions()
        suggestionsTableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        suggestionsTableView.isHidden = true
        suggestionsTableView.suggestions.removeAll()
        suggestionsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchBarText = self.searchController.searchBar.text!
        if !searchBarText.isEmpty {
            updateSearchSuggestions()
        }
    }
    
    func updateSearchSuggestions() {
        let searchBarText = self.searchController.searchBar.text!
        DispatchQueue.global(qos: .userInitiated).async {
            MusicFetcher.fetchYoutubeAutocomplete(searchQuery: searchBarText, handler: { suggestions in
                self.suggestionsTableView.suggestions = suggestions
                DispatchQueue.main.async {
                    self.suggestionsTableView.reloadData()
                }
            })
        }
    }
    
//    func setCollectionBackground() {
//        if self.musicTableView.musicArray.count == 0 {
//            self.musicTableView.showNoResults()
//        } else {
//            self.musicTableView.backgroundView = nil
//        }
//    }
    
    @objc func updateSearchResults() {
        let searchBarText = self.searchController.searchBar.text!
        DispatchQueue.global(qos: .userInitiated).async {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            MusicFetcher.fetchYoutube(keywords: searchBarText) { (youtubeVideos) -> Void in
                //                    DispatchQueue.main.async {
                //                        self.musicTableView.showLoading()
                //                    }
                if let youtubeVideos = youtubeVideos {
                    self.musicTableView.musicArray = youtubeVideos
                    DispatchQueue.main.async {
                        self.musicTableView.reloadData()
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                //self.setCollectionBackground()
            }
        }
    }
    
}
