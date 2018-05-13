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
        //register(LoadingTableViewCell.self, forHeaderFooterViewReuseIdentifier: loadingCellId)
    }
    
    let loadingCellId = "loadingCellId"
    var handleMusicTapped: (()->())?
    var bottomReached: (()->())?
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: musicCellId, for: indexPath) as! SearchMusicTableViewCell
        cell.music = musicArray[indexPath.row]
        cell.addMusic = {
            TEMPSessionData.queueMusic.append(cell.music!)
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
        let queue = UITableViewRowAction(style: .destructive, title: "QUEUE", handler: { action, indexPath in
            TEMPSessionData.queueMusic.append(self.musicArray[indexPath.row])
        })
        queue.backgroundColor = Constants.Colors().secondaryColor
        
        let save = UITableViewRowAction(style: .normal, title: "SAVE", handler: { action, indexPath in
            
        })
        save.backgroundColor = Constants.Colors().primaryColor
        
        return [queue, save]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
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
