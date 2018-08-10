//
//  PlaylistDetailsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import Foundation

class PlaylistDetailsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.titleView = titleLabelView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.alwaysBounceVertical = false
        
        tableView.register(PlaylistHeaderCell.self, forCellReuseIdentifier: detailsCellId)
        tableView.register(PlaylistControlsTableViewCell.self, forCellReuseIdentifier: controlsCellId)
        tableView.register(AddMusicTableViewCell.self, forCellReuseIdentifier: addMusicCellId)
        tableView.register(QueueMusicTableViewCell.self, forCellReuseIdentifier: songCellId)
        setUpTheming()
    }
    
    // TODO: fix large title appearance when going back and forth swiping nav
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if let nav = navigationController {
            nav.navigationBar.prefersLargeTitles = false
        }
        if playlist!.size > 0 {
            tableView.tableFooterView = UIView()
        } else {
            tableView.tableFooterView = backgroundView
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = navigationController {
            nav.navigationBar.prefersLargeTitles = true
        }
        navigationController?.view.layoutSubviews()
    }
    
    var playlistSize: Int {
        return Int(playlist!.size)
    }
    
    let backgroundView: AddSongsView = {
        let view = AddSongsView(buttonText: "FIND MUSIC", description: "There's nothing in here")
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        return view
    }()
    
    let titleLabelView: UILabel = {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let titleFadeAnimation: CATransition = {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = kCATransitionFade
        animation.subtype = kCATransitionFromTop
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }()
    
    let playlistEditAlert = PlaylistEditAlertController()
    
    var playlist: Playlist? {
        didSet {
            guard let playlist = playlist else { return }
            title = playlist.title
        }
    }
    let detailsCellId = "detailsCellId"
    let controlsCellId = "controlsCellId"
    let addMusicCellId = "addMusicCellId"
    let songCellId = "songCellId"
    
    var numberOfRowsInSection: [Int] {
        guard let playlist = playlist else { return [2, 0] }
        let playlistSize = Int(exactly: NSNumber(value: playlist.size))!
        return [2, playlistSize]
    }
    var heightForRowAt: [Any] = [
        [ UIScreen.main.bounds.width * 0.373 + 30, 74 ],
        60
    ]
    var canEditRowAt: [Any] = [
        [false, true],
        true
    ]
    var editingStyleForRowAt: [Any] = [
        [UITableViewCellEditingStyle.none, UITableViewCellEditingStyle.insert],
        UITableViewCellEditingStyle.delete
    ]
    
    lazy var removeAction = UITableViewRowAction(style: .destructive, title: "REMOVE", handler: { (action, indexPath) in
        guard let playlist = self.playlist else { return }
        CoreDataHelper.shared.getContext().performAndWait({
            playlist.removeSong(at: indexPath.row)
        })
        CoreDataHelper.shared.appDelegate.saveContext()
        self.tableView.performBatchUpdates({
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }, completion: nil)
    })
    lazy var editActionsForRowAt: [Any] = [
        [],
        [self.removeAction]
    ]
    
    var canMoveRowAt: [Any] = [
        false,
        true
    ]
    
    // TODO: fix swipe remove shouldnt start editing mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
//        tableView.setEditing(!editing, animated: false)
//        tableView.setEditing(editing, animated: animated)
        if playlistSize > 0 {
            if editing {
                let insertIndexPath = [IndexPath(row: 1, section: 0)]
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: insertIndexPath, with: .fade)
                    tableView.insertRows(at: insertIndexPath, with: .fade)
                }, completion: nil)
            } else {
                let insertIndexPath = [IndexPath(row: 1, section: 0)]
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: insertIndexPath, with: .fade)
                    tableView.insertRows(at: insertIndexPath, with: .fade)
                }, completion: nil)
            }
        }
    }
    
    func playPlaylist() {
        guard let playlistSongs = playlist?.getSongsArray() else { return }
        UpNextWrapper.shared.setUpNextSongs(songs: playlistSongs)
        UpNextWrapper.shared.setCurrentlyPlayingIndex(index: 0)
    }
    
    func shufflePlayPlaylist() {
        guard var playlistSongs = playlist?.getSongsArray() else { return }
        playlistSongs.shuffle()
        UpNextWrapper.shared.setUpNextSongs(songs: playlistSongs)
        UpNextWrapper.shared.setCurrentlyPlayingIndex(index: 0)
    }
    
}

// MARK: - Table View Data Source
extension PlaylistDetailsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfRowsInSection.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if playlist!.size > 0 {
                return 2
            }
            return 1
        } else {
            return Int(playlist!.size)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return createDetailHeaderCell(indexPath: indexPath)
            } else {
                if !isEditing {
                    let cell = tableView.dequeueReusableCell(withIdentifier: controlsCellId) as! PlaylistControlsTableViewCell
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                    cell.play = {
                        self.playPlaylist()
                    }
                    cell.shuffle = {
                        self.shufflePlayPlaylist()
                    }
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: addMusicCellId) as! AddMusicTableViewCell
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                    return cell
                }
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: songCellId, for: indexPath) as! QueueMusicTableViewCell
            cell.music = playlist?.getSongNode(at: indexPath.row)?.song
            cell.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
            cell.isUserInteractionEnabled = true
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func createDetailHeaderCell(indexPath: IndexPath) -> PlaylistHeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellId, for: indexPath) as! PlaylistHeaderCell
        //                cell.linkButtonTapped = {
        //                    self.handleLinkTapped?()
        //                }
        cell.editButtonTapped = {
            self.present(self.playlistEditAlert, animated: true, completion: nil)
        }
        cell.playlist = playlist
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let canEdits = canEditRowAt[indexPath.section] as? [Bool] {
            return canEdits[indexPath.row]
        }
        else if let canEdit = canEditRowAt[indexPath.section] as? Bool {
            return canEdit
        }
        return false
    }
    
    //    override func setEditing(_ editing: Bool, animated: Bool) {
    //        super.setEditing(editing, animated: animated)
    //        // Reset to handle case where cell is swiped to be edited
    //        tableView.setEditing(!editing, animated: false)
    //        tableView.setEditing(editing, animated: animated)
    //    }
    
}

// MARK: - Table View Delegate
extension PlaylistDetailsController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playlist = playlist else { return }
        UpNextWrapper.shared.setUpNextSongs(songs: playlist.getSongsArray())
        UpNextWrapper.shared.setCurrentlyPlayingIndex(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.getArrayResult(type: CGFloat.self, array: heightForRowAt, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableView.getArrayResult(type: UITableViewCellEditingStyle.self, array: editingStyleForRowAt, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //return UITableView.getArrayResult(type: [UITableViewRowAction].self, array: editActionsForRowAt, indexPath: indexPath)
        return nil
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let song = playlist?.getSongNode(at: indexPath.row)?.song else { return nil }
        
        let queue = UIContextualAction(style: .normal, title: "QUEUE", handler: { (action, view, completion) in
            CoreDataHelper.shared.queue?.insertSongAtEnd(song: song)
            song.setSaved(saved: false, retain: true)
            completion(true)
        })
        queue.backgroundColor = Constants.Colors().secondaryColor
        
        let add = UIContextualAction(style: .normal, title: "ADD", handler: { (action, view, completion) in
            guard let nav = self.navigationController else { return }
            let addSongController = AddController()
            addSongController.song = song
            let addSongNav = CustomNavigationController(rootViewController: addSongController)
            nav.present(addSongNav, animated: true, completion: nil)
            completion(true)
        })
        add.backgroundColor = Constants.Colors().primaryColor
        
        let delete = UIContextualAction(style: .normal, title: "REMOVE", handler: { (action, view, completion) in
            guard let playlist = self.playlist else { return }
            CoreDataHelper.shared.getContext().performAndWait({
                playlist.removeSong(at: indexPath.row)
            })
            CoreDataHelper.shared.appDelegate.saveContext()
            self.tableView.performBatchUpdates({
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }, completion: nil)
            completion(true)
        })
        delete.backgroundColor = .red
        
        let config = UISwipeActionsConfiguration(actions: [delete, queue, add])
        
        return config
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return UITableView.getArrayResult(type: Bool.self, array: canMoveRowAt, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.section == 1 {
            guard let playlist = playlist else { return }
            CoreDataHelper.shared.getContext().performAndWait {
                playlist.moveSong(from: sourceIndexPath.row, to: destinationIndexPath.row)
            }
            CoreDataHelper.shared.appDelegate.saveContext()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // b/c dark theme navbar is translucent so it scrolls offset more before >30
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let maxScrollOffset = 30
        if scrollView.contentOffset.y + statusBarHeight + 44 > CGFloat(maxScrollOffset) {
            (navigationItem.titleView as? UILabel)?.text = playlist?.title!
        } else {
            (navigationItem.titleView as? UILabel)?.text = ""
        }
    }
    
}

// MARK: - Theme
extension PlaylistDetailsController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.separatorColor = theme.tableSeparatorColor
        titleLabelView.textColor = theme.textColor
    }
}



