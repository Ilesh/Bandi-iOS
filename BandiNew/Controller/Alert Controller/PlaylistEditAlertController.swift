//
//  PlaylistEditAlertController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistEditAlertController: UIAlertController {
    
    var playlist: Playlist?
    var playlistDeleted: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Alert canceled")
        })
        let deleteAction = UIAlertAction(title: "Delete Playlist", style: .destructive, handler: { action in
            guard let playlist = self.playlist else { return }
            let context = CoreDataHelper.shared.getContext()
            context.delete(playlist)
            CoreDataHelper.shared.appDelegate.saveContext()
            self.playlistDeleted?()
        })
        let shareLinkAction = UIAlertAction(title: "Share Playlist", style: .default, handler: { action in
            print("New link requested")
        })
        
        addAction(shareLinkAction)
        addAction(deleteAction)
        addAction(cancelAction)
        
    }
    
}
