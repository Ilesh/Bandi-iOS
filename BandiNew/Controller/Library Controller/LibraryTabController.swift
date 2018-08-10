//
//  LibraryTabController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/9/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class LibraryTabController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Library"
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings-50"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsButton
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: libraryCellId)
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = navigationController {
            navBar.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.layoutSubviews()
    }
    
    let libraryCellId = "libraryCellId"
    let cellTitles = ["Playlists", "All Songs", "Queue"]
    
    @objc func openSettings() {
    
    }
    
}

// MARK: - Table View Data Source
extension LibraryTabController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: libraryCellId, for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.text = cellTitles[indexPath.row]
        cell.textLabel?.font = cell.textLabel?.font.withSize(22)
        cell.textLabel?.textColor = Constants.Colors().primaryColor
        cell.textLabel?.highlightedTextColor = .white
        cell.accessoryView?.tintColor = .white
        let selectedView = UIView()
        selectedView.backgroundColor = Constants.Colors().primaryColor
        cell.selectedBackgroundView = selectedView
        if indexPath.row != 2 {
            cell.accessoryType = .disclosureIndicator
        }
    }
    
}

// MARK: - Table View Delegate
extension LibraryTabController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let navController = navigationController else { return }
            let playlistsController = PlaylistsController(style: .grouped)
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

// MARK: - Theme
extension LibraryTabController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.separatorColor = theme.tableSeparatorColor
    }
}
