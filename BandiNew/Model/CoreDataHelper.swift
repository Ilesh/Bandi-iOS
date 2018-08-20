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
    
    init() { }
    
    static let shared = CoreDataHelper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var persistentContainer = appDelegate.persistentContainer
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    private let recentSearchesFetchRequest: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
    private let MAX_RECENT_SEARCHES = 4
    
    public var queue: Playlist?
    public var allSongs: [Song] {
        do {
            return try context.fetch(allSongsFetch)
        } catch {
            return [Song]()
        }
    }
    public var userPlaylists: [Playlist] {
        do {
            return try context.fetch(userPlaylistsFetch)
        } catch {
            return [Playlist]()
        }
    }
    
    func getPersistentContainer() -> NSPersistentContainer {
        return persistentContainer
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
    
    fileprivate lazy var userPlaylistsFetch: NSFetchRequest<Playlist> = {
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let onlyUserPlaylists = NSPredicate(format: "%K == %@", "orderRank", "0")
        let onlySavedPlaylists = NSPredicate(format: "%K == %@", "saved", NSNumber(value: true))
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [onlyUserPlaylists, onlySavedPlaylists])
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = predicate
        return fetchRequest
    }()
    
    fileprivate lazy var allSongsFetch: NSFetchRequest<Song> = {
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        let alphabeticalSort = NSSortDescriptor(key: "title", ascending: true)
        let isSaved = NSPredicate(format: "%K == %@", "saved", NSNumber(value: true))
        fetchRequest.sortDescriptors = [alphabeticalSort]
        fetchRequest.predicate = isSaved
        return fetchRequest
    }()
    
    func initialCoreDataSetup() {
        
        do {
            let playlistsFetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
            let playlists = try self.context.fetch(playlistsFetchRequest)
            for playlist in playlists {
                if playlist.type == "queue" {
                    self.queue = playlist
                    break
                }
            }
        } catch {
            print(error)
        }
        
        if self.queue == nil {
            context.performAndWait({
                let playlist = Playlist(context: self.context)
                playlist.saved = true
                playlist.type = "queue"
                playlist.orderRank = 1
                let currentDate = Date()
                playlist.dateCreated = currentDate
                playlist.dateModified = currentDate
                playlist.id = ""
                playlist.playlistDescription = "queue playlist"
                playlist.title = "Queue"
                playlist.size = 0
                self.queue = playlist
            })
            print("created queue")
        }
        
    }
    
    func createSongToPlaylist(song: Song, playlist: Playlist) -> SongToPlaylist? {
        var songToPlaylist: SongToPlaylist?
        context.performAndWait({
            songToPlaylist = SongToPlaylist(context: self.context)
            guard let songToPlaylist = songToPlaylist else { return }
            songToPlaylist.song = song
            songToPlaylist.playlist = playlist
            songToPlaylist.dateModified = Date()
        })
        return songToPlaylist
    }
    
    // MARK: - Recent Search
    
    func addRecentSearch(searchString: String) {
        let dateSort = NSSortDescriptor(key: "searchDate", ascending: true)
        recentSearchesFetchRequest.sortDescriptors = [dateSort]
        do {
            let fetchedSearches = try context.fetch(recentSearchesFetchRequest)
            self.context.perform({
                if fetchedSearches.count + 1 > self.MAX_RECENT_SEARCHES {
                    self.context.delete(fetchedSearches.first!)
                }
                let newRecentSearch = RecentSearch(context: self.context)
                newRecentSearch.searchText = searchString
                newRecentSearch.searchDate = Date()
                self.appDelegate.saveContext()
            })
        } catch {
            print(error)
        }
    }
    
    func clearRecentSearches() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: self.recentSearchesFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try self.context.execute(batchDeleteRequest)
        } catch {
            print("error: \(error)")
        }
    }
    
}
