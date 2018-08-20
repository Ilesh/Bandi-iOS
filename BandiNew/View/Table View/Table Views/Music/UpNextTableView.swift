//
//  UpNextTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/9/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class UpNextTableView: MusicTableView {
    
    init(frame: CGRect, style: UITableViewStyle, playlist: Playlist?) {
        super.init(frame: frame, style: style)
        
        setEditing(true, animated: false)
        isScrollEnabled = false
        
        allowsSelectionDuringEditing = true
        
        register(UpNextHeaderTableViewCell.self, forCellReuseIdentifier: upNextHeaderId)
        register(UpNextTableViewCell.self, forCellReuseIdentifier: upNextCellId)
        setupViews()
    }
    
    override var musicArray: [Song] {
        get {
            return UpNextWrapper.shared.getUpNextSongs()
        }
        set (songs) {
            UpNextWrapper.shared.setUpNextSongs(songs: songs)
        }
    }
    
    var upNextIndex: Int {
        return UpNextWrapper.shared.getCurrentlyPlayingIndex() + 1
    }
    
    var selectedRow: ((Int)->())?
    var handleScrollDownTapped: (()->())?
    var recalculateFrame: (()->())?
    let upNextHeaderId = "upNextHeaderId"
    let upNextCellId = "upNextCellId"
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    func getCalculatedHeight() -> Int {
        return (musicArray.count - upNextIndex) * 60 + 105
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return musicArray.count - upNextIndex
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 105
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = dequeueReusableCell(withIdentifier: upNextHeaderId) as! UpNextHeaderTableViewCell
            cell.scrollDownTapped = {
                self.handleScrollDownTapped?()
            }
            cell.scrollDownButton.isHidden = musicArray.count == 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            return cell
        } else {
            let cell = dequeueReusableCell(withIdentifier: upNextCellId) as! UpNextTableViewCell
            cell.music = musicArray[indexPath.row + upNextIndex]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 { return nil }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow?(indexPath.row + upNextIndex)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let remove = UIContextualAction(style: .destructive, title: "REMOVE", handler: { (action, view, completion) in
                //guard let playlist = self.playlist else { return }
                print(1234)
//                CoreDataHelper.shared.getContext().performAndWait({
//                    playlist.removeSong(at: indexPath.row)
//                })
//                CoreDataHelper.shared.appDelegate.saveContext()
//                tableView.performBatchUpdates({
//                    tableView.deleteRows(at: [indexPath], with: .none)
//                }, completion: nil)
                self.recalculateFrame?()
                completion(true)
            })
            return UISwipeActionsConfiguration(actions: [remove])
        }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "REMOVE", handler: { (action, indexPath) in
            self.musicArray.remove(at: indexPath.row)
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .left)
            }, completion: nil)
        })
        return [removeAction]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath.row != sourceIndexPath.row ? proposedDestinationIndexPath : sourceIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.section == 1 {
            if sourceIndexPath.row == destinationIndexPath.row { return }
            musicArray.rearrange(from: sourceIndexPath.row + upNextIndex, to: destinationIndexPath.row + upNextIndex)
            UpNextWrapper.shared.setUpNextSongs(songs: musicArray)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
