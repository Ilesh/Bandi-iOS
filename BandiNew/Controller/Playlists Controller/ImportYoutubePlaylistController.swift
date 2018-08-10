//
//  ImportYoutubePlaylistController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class ImportYoutubePlaylistController: CreatePlaylistController {
    
    init(playlistId: String) {
        super.init(style: .plain)
        self.playlistId = playlistId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let playlistId = self.playlistId else { return }
        playlistFetcher.fetchYoutubePlaylistDetails(playlistId: playlistId, handler: { playlist in
            playlist.saved = false
            self.playlist = playlist
            self.playlistTitle = playlist.title!
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.playlistFetcher.fetchYoutubePlaylistSongs(playlistId: playlistId, handler: { songs in
                    for song in songs! {
                        if self.requestAborted { return }
                        CoreDataHelper.shared.getContext().performAndWait({
                            self.playlist?.insertSongAtEnd(song: song)
                            song.setSaved(saved: false, retain: true)
                        })
                    }
                    CoreDataHelper.shared.appDelegate.saveContext()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.loading.stopAnimating()
                        self.tableView.tableFooterView = nil
                    }
                })
            }
            
        })
        
        tableView.tableFooterView = loading
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController && playlist != nil {
            requestAborted = true
            let context = CoreDataHelper.shared.getContext()
            context.perform({
                context.delete(self.playlist!)
            })
        }
    }
    
    var playlistId: String?
    let playlistFetcher = MusicFetcher()
    var requestAborted = false
    
    let loading: UIActivityIndicatorView = {
        let l = UIActivityIndicatorView()
        l.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        l.startAnimating()
        return l
    }()
    
    
}
