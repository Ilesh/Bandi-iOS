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
        register(SearchMusicTableViewCell.self, forCellReuseIdentifier: musicCellId)
    }
    
    var handleMusicTapped: (()->())?
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results :("
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func showNoResults() {
        backgroundView = noResultsLabel
    }
    
    func showLoading() {
        backgroundView = loadingView
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = dequeueReusableCell(withIdentifier: musicCellId, for: indexPath) as! SearchMusicTableViewCell
        cell.music = musicArray[indexPath.row]
        cell.addMusic = {
            TEMPSessionData.queueMusic.append(cell.music!)
        }
        cell.swipeStarted = {
            self.handleSwipeStarted?()
        }
        cell.musicTapped = {
            self.handleMusicTapped?()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let queue = UITableViewRowAction(style: .destructive, title: "QUEUE") { (action, indexPath) in
            TEMPSessionData.queueMusic.append(self.musicArray[indexPath.row])
        }
        queue.backgroundColor = Constants.Colors().primaryColor
        
        return [queue]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
