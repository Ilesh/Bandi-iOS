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
        
        register(QueueMusicTableViewCell.self, forCellReuseIdentifier: musicCellId)
    }

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
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = dequeueReusableCell(withIdentifier: musicCellId, for: indexPath) as! QueueMusicTableViewCell
        cell.music = musicArray[indexPath.row]
        cell.removeMusic = {
            if let currentIndexPath = self.indexPath(for: cell) {
                TEMPSessionData.queueMusic.remove(at: currentIndexPath.row)
                self.musicArray.remove(at: currentIndexPath.row)
                self.deleteRows(at: [currentIndexPath], with: .left)
                self.handleMusicRemoved?()
            }
        }
        cell.swipeStarted = {
            self.handleSwipeStarted?()
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
        let delete = UITableViewRowAction(style: .destructive, title: "DELETE") { (action, indexPath) in
            self.musicArray.remove(at: indexPath.row)
            TEMPSessionData.queueMusic = self.musicArray
            self.performBatchUpdates({
                self.deleteRows(at: [indexPath as IndexPath], with: .left)
            }, completion: nil)
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.musicArray[sourceIndexPath.row]
        musicArray.remove(at: sourceIndexPath.row)
        musicArray.insert(movedObject, at: destinationIndexPath.row)
        TEMPSessionData.queueMusic = musicArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
