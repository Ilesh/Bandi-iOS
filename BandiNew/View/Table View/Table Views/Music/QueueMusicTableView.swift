//
//  QueueMusicTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueMusicTableView: MusicTableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        register(QueueHeaderViewCell.self, forCellReuseIdentifier: queueMainCellId)
        register(PlaylistControlsTableViewCell.self, forCellReuseIdentifier: playlistControlsCellId)
        register(AddMusicTableViewCell.self, forCellReuseIdentifier: addMusicCellId)
        register(QueueMusicTableViewCell.self, forCellReuseIdentifier: musicCellId)
    }
    
    let queueMainCellId = "queueMainCellId"
    let playlistControlsCellId = "playlistControlsCellId"
    let addMusicCellId = "addMusicCellId"
    let queueLinkCellId = "queueLinkCellId"
    var handleLinkTapped: (()->())?
    var handleEditTapped: (()->())?
    var handleMusicRemoved: (()->())?
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results :("
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noQueueLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing Queued :O"
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func showNoResults() {
        backgroundView = noResultsLabel
    }
    
    func showNoQueue() {
        backgroundView = noQueueLabel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print (musicArray.count == 0 ? 1 : 2)
        return musicArray.count == 0 ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return musicArray.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return UIScreen.main.bounds.width * 0.373 + 30
            } else {
                return 74
            }
        } else {
            return 60
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = dequeueReusableCell(withIdentifier: queueMainCellId) as! QueueHeaderViewCell
                cell.linkButtonTapped = {
                    self.handleLinkTapped?()
                }
                cell.editButtonTapped = {
                    self.handleEditTapped?()
                }
                cell.layoutMargins = UIEdgeInsets.zero
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                return cell
            } else {
                if !isEditing {
                    let cell = dequeueReusableCell(withIdentifier: playlistControlsCellId) as! PlaylistControlsTableViewCell
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                    return cell
                } else {
                    let cell = dequeueReusableCell(withIdentifier: addMusicCellId) as! AddMusicTableViewCell
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                    return cell
                }
            }
        } else {
            let cell = dequeueReusableCell(withIdentifier: musicCellId, for: indexPath) as! QueueMusicTableViewCell
            cell.music = musicArray[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            let insertIndexPath = [IndexPath(row: 1, section: 0)]
            performBatchUpdates({
                deleteRows(at: insertIndexPath, with: .fade)
                insertRows(at: insertIndexPath, with: .fade)
            }, completion: nil)
        } else {
            let insertIndexPath = [IndexPath(row: 1, section: 0)]
            performBatchUpdates({
                deleteRows(at: insertIndexPath, with: .fade)
                insertRows(at: insertIndexPath, with: .fade)
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                return UITableViewCellEditingStyle.insert
            } else {
                return UITableViewCellEditingStyle.none
            }
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 1 {
            let remove = UITableViewRowAction(style: .destructive, title: "REMOVE") { (action, indexPath) in
                self.musicArray.remove(at: indexPath.row)
                TEMPSessionData.queueMusic = self.musicArray
                self.performBatchUpdates({
                    self.deleteRows(at: [indexPath], with: .left)
                }, completion: nil)
            }
            return [remove]
        }
        return []
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


