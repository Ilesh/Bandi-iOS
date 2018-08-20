//
//  SearchMusicTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchMusicTableView: MusicTableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        allowsSelection = true
        register(SearchMusicTableViewCell.self, forCellReuseIdentifier: musicCellId)
        setupViews()
        setUpTheming()
    }
    
    let loadingCellId = "loadingCellId"
    var handleMusicTapped: ((Song)->())?
    var bottomReached: (()->())?
    var addSong: ((Song)->())?
    var isSearching = false
    
    private let topBorderView = UIView()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results :("
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func applyTheme(_ theme: AppTheme) {
        super.applyTheme(theme)
        loadingView.activityIndicatorViewStyle = theme.loadingCircleStyle
        topBorderView.backgroundColor = theme.tableBackgroundColor
    }
    
    func showNoResults() {
        backgroundView = noResultsLabel
    }
    
    func showLoading() {
        loadingView.startAnimating()
        backgroundView = loadingView
    }
    
    func clearBackgroundView() {
        loadingView.stopAnimating()
        backgroundView = nil
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(topBorderView)
        topBorderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
    }
    
    override func reloadData() {
        super.reloadData()
        if isSearching {
            showLoading()
        }
        else if !isSearching && musicArray.count == 0 {
            showNoResults()
        }
        else {
            clearBackgroundView()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: musicCellId, for: indexPath) as! SearchMusicTableViewCell
        cell.music = musicArray[indexPath.row]
        cell.addMusic = {
            self.addSong?(self.musicArray[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.handleMusicTapped?(self.musicArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let queue = UIContextualAction(style: .normal, title: "QUEUE", handler: { (action, view, completion) in
            let song = self.musicArray[indexPath.row]
            CoreDataHelper.shared.queue?.insertSongAtEnd(song: song)
            song.setSaved(saved: false, retain: true)
            completion(true)
        })
        queue.backgroundColor = Constants.Colors().secondaryColor
        
        let save = UIContextualAction(style: .normal, title: "ADD", handler: { (action, view, completion) in
            self.addSong?(self.musicArray[indexPath.row])
            completion(true)
        })
        save.backgroundColor = Constants.Colors().primaryColor
        
        let config = UISwipeActionsConfiguration(actions: [queue, save])
        
        return config
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isSearching || (!isSearching && musicArray.count == 0){
            return nil
        }
        return LoadingTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        bottomReached?()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

