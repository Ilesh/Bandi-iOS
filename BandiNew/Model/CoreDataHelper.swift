//
//  CoreDataHelper.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 6/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var persistentContainer = appDelegate.persistentContainer
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    public var queue: Playlist?
    public var allSongs: Playlist?
    
    func getPersistentContainer() -> NSPersistentContainer {
        return persistentContainer
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
    
    func initialCoreDataSetup() {
        
        let playlistsFetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        
        do {
            let playlists = try self.context.fetch(playlistsFetchRequest)
            for playlist in playlists {
                if playlist.type == "queue" {
                    if self.queue == nil {
                        self.queue = playlist
                        print("queue found")
                    } else {
                        print("duplicate queue")
                    }
                }
                if playlist.type == "allSongs" {
                    if self.allSongs == nil {
                        self.allSongs = playlist
                        print("allSongs found")
                    } else {
                        print("duplicate allSongs")
                    }
                }
            }
        } catch {
            print(error)
        }
        
        if self.queue == nil {
            context.perform({
                let playlist = Playlist(context: self.context)
                playlist.type = "queue"
                let currentDate = Date()
                playlist.dateCreated = currentDate
                playlist.dateModified = currentDate
                playlist.id = ""
                playlist.playlistDescription = "queue playlist"
                playlist.title = "Queue"
                playlist.size = 0
                self.queue = playlist
            })
        }
        
        if self.allSongs == nil {
            context.perform({
                let playlist = Playlist(context: self.context)
                playlist.type = "allSongs"
                let currentDate = Date()
                playlist.dateCreated = currentDate
                playlist.dateModified = currentDate
                playlist.id = ""
                playlist.playlistDescription = "allSongs playlist"
                playlist.title = "All Songs"
                playlist.size = 0
                self.allSongs = playlist
            })
        }
        
    }
    
    func createSongToPlaylist(song: Song, playlist: Playlist) -> SongToPlaylist {
        var songToPlaylist: SongToPlaylist?
        context.performAndWait({
            songToPlaylist = SongToPlaylist(context: self.context)
            guard let songToPlaylist = songToPlaylist else { return }
            songToPlaylist.song = song
            songToPlaylist.playlist = playlist
            songToPlaylist.dateModified = Date()
        })
        return songToPlaylist!
    }
    
}
