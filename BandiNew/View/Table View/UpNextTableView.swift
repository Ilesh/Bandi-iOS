//
//  UpNextTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/9/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class UpNextTableView: MusicTableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        isEditing = true
        backgroundColor = Constants.Colors().darkTableCell
        isScrollEnabled = false
        register(UpNextHeaderTableViewCell.self, forCellReuseIdentifier: upNextHeaderId)
        register(UpNextTableViewCell.self, forCellReuseIdentifier: upNextCellId)
        setupViews()
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
        return musicArray.count * 60 + 105
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return musicArray.count
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
            return cell
        } else {
            let cell = dequeueReusableCell(withIdentifier: upNextCellId) as! UpNextTableViewCell
            cell.music = musicArray[indexPath.row]
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
            let movedObject = self.musicArray[sourceIndexPath.row]
            musicArray.remove(at: sourceIndexPath.row)
            musicArray.insert(movedObject, at: destinationIndexPath.row)
            TEMPSessionData.queueMusic = musicArray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
