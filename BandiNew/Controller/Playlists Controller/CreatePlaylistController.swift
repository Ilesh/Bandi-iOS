//
//  CreatePlaylistController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/1/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class CreatePlaylistController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBar = navigationController {
            navBar.navigationBar.prefersLargeTitles = false
        }
        
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(completePlaylistCreation))
        navigationItem.rightBarButtonItem = doneBarButton
        
        title = "Create Playlist"
        
        tableView.tableFooterView = UIView()
        tableView.isEditing = true
        tableView.register(CreatePlaylistHeaderTableViewCell.self, forCellReuseIdentifier: playlistHeaderCellId)
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: createPlaylistCellId)
        tableView.register(UpNextTableViewCell.self, forCellReuseIdentifier: cellId)
        setUpTheming()
    }
    
    let playlistHeaderCellId = "playlistHeaderCellId"
    let createPlaylistCellId = "createPlaylistCellId"
    let cellId = "cellId"
    var playlist: Playlist?
    var playlistTitle: String = "Untitled"
    
    @objc func completePlaylistCreation() {
        let context = CoreDataHelper.shared.getContext()
        context.perform({
            if self.playlist == nil {
                self.playlist = Playlist(context: context)
                self.playlist?.size = 0
            }
            self.playlist?.saved = true
            self.playlist?.type = "user"
            self.playlist?.orderRank = 0
            let currentDate = Date()
            self.playlist?.dateCreated = currentDate
            self.playlist?.dateModified = currentDate
            self.playlist?.id = ""
            self.playlist?.title = self.playlistTitle
            self.playlist?.playlistDescription = "TODO"
            for song in self.playlist!.getSongsArray() {
                song.setSaved(saved: true, retain: true)
            }
            CoreDataHelper.shared.appDelegate.saveContext()
        })
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController && playlist != nil {
            let context = CoreDataHelper.shared.getContext()
            context.perform({
                context.delete(self.playlist!)
            })
        }
    }
    
}

// MARK: - Table View Data Source
extension CreatePlaylistController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            if playlist != nil {
                return Int(playlist!.size)
            } else {
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: playlistHeaderCellId, for: indexPath) as! CreatePlaylistHeaderTableViewCell
            if playlist != nil {
                cell.setPlaylistTitle(title: playlist!.title!)
            }
            cell.playlistNameUpdated = { title in
                self.playlistTitle = title
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: createPlaylistCellId, for: indexPath)
            cell.textLabel?.text = "Add Music"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UpNextTableViewCell
        cell.music = playlist?.getSongNode(at: indexPath.row)?.song
        cell.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.section == 2 {
            guard let playlist = playlist else { return }
            CoreDataHelper.shared.getContext().performAndWait {
                playlist.moveSong(from: sourceIndexPath.row, to: destinationIndexPath.row)
            }
            CoreDataHelper.shared.appDelegate.saveContext()
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            return .none
        } else if indexPath.section == 1 {
            return .insert
        }
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section != 2 { return nil }
        let removeAction = UITableViewRowAction(style: .destructive, title: "REMOVE", handler: { (action, indexPath) in
            guard let playlist = self.playlist else { return }
            CoreDataHelper.shared.getContext().performAndWait({
                playlist.removeSong(at: indexPath.row)
            })
            CoreDataHelper.shared.appDelegate.saveContext()
            self.tableView.performBatchUpdates({
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }, completion: nil)
        })
        return [removeAction]
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return  false
    }
    
}

// MARK: - Table View Delegate
extension CreatePlaylistController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return UIScreen.main.bounds.width * 0.373 + 30
            }
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if indexPath.section == 2 {
//            let cell = tableView.cellForRow(at: indexPath) as! CreatePlaylistHeaderTableViewCell
//            print(cell)
//        }
//    }
    
}

// MARK: - Theme
extension CreatePlaylistController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.tableBackgroundColor
        tableView.separatorColor = theme.tableSeparatorColor
    }
}
