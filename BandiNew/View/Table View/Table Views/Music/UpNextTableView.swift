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
        self.playlist = playlist
        
        isEditing = true
        isScrollEnabled = false
        
        register(UpNextHeaderTableViewCell.self, forCellReuseIdentifier: upNextHeaderId)
        register(UpNextTableViewCell.self, forCellReuseIdentifier: upNextCellId)
        setupViews()
    }
    
    var playlist: Playlist?
    var playlistSize: Int {
        guard let playlist = self.playlist else { return 0 }
        return Int(playlist.size)
    }
    var handleScrollDownTapped: (()->())?
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
        return playlistSize * 60 + 105
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return playlistSize == 0 ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return playlistSize
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
            cell.scrollDownButton.isHidden = playlistSize == 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            return cell
        } else {
            let cell = dequeueReusableCell(withIdentifier: upNextCellId) as! UpNextTableViewCell
            cell.music = playlist?.getSongNode(at: indexPath.row)?.song
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.section == 1 {
            guard let playlist = self.playlist else { return }
            playlist.moveSong(from: sourceIndexPath.row, to: destinationIndexPath.row)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
