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
    
        navigationItem.rightBarButtonItem = self.editButtonItem
        let barButton = UIBarButtonItem(title: "Theme", style: UIBarButtonItemStyle.plain, target: self, action: #selector(themeTapped))
        navigationItem.leftBarButtonItem = barButton
        
        title = "Queue"
        setupViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.musicTableView.musicArray = TEMPSessionData.queueMusic
        self.musicTableView.reloadData()
    }
    
    var searchBarShownHeight: NSLayoutConstraint?
    var searchBarHiddenHeight: NSLayoutConstraint?
    
    @objc func themeTapped() {
        AppThemeProvider.shared.nextTheme()
    }
    
    
    lazy var musicTableView: QueueMusicTableView = {
        let cv = QueueMusicTableView(frame: .zero, style: UITableViewStyle.plain)
        cv.musicArray = TEMPSessionData.queueMusic
        cv.handleScroll = { (isUp) -> () in
            if TEMPSessionData.queueMusic.count != 0 {
                //self.showSearchBar(show: !isUp)
            }
        }
        cv.handleLinkTapped = {
            //let activityVC = UIActivityViewController(title: nil, message: nil, preferredStyle: UIActivityIndicatorViewStyle.gray, blurStyle: .dark)
            let activityVC = UIActivityViewController(activityItems: ["REPLACE THIS LINK"], applicationActivities: nil)
            //activityVC.view.backgroundColor = Constants.Colors().darkTableCell
            self.present(activityVC, animated: true, completion: nil)
        }
        cv.handleEditTapped = {
            let alert = QueueEditAlertController(title: nil, message: nil, preferredStyle: .actionSheet) //QueueEditAlertController(title: nil, message: nil, preferredStyle: .actionSheet, blurStyle: .dark)
            self.present(alert, animated: true, completion: nil)
        }
        cv.handleSwipeStarted = {
            //self.showSearchBar(show: false)
        }
        cv.handleMusicRemoved = {
            //self.setCollectionBackground()
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
        
        musicTableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Reset to handle case where cell is swiped to be edited
        musicTableView.setEditing(!editing, animated: false)
        musicTableView.setEditing(editing, animated: animated)
    }
    
//
//    func updateSearchResults() {
//        if let text = searchBar.text, !text.isEmpty {
//            self.musicTableView.musicArray = TEMPSessionData.queueMusic.filter({ (music) -> Bool in
//                return (music.title?.lowercased().contains(text.lowercased()))!
//            })
//        } else {
//            self.musicTableView.musicArray = TEMPSessionData.queueMusic
//        }
//        setCollectionBackground()
//        self.musicTableView.reloadData()
//    }
    
}
