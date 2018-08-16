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
    
    private let MAX_RECENT_SEARCHES = 4
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var persistentContainer = appDelegate.persistentContainer
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    private let recentSearchesFetchRequest: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
    
    public var queue: Playlist?
    public var allSongs: Playlist?
    
    func getPersistentContainer() -> NSPersistentContainer {
        return persistentContainer
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
    
    lazy var playlistFetchedResultsController: NSFetchedResultsController<Playlist> = {
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let onlyUserPlaylists = NSPredicate(format: "%K == %@", "orderRank", "0")
        let onlySavedPlaylists = NSPredicate(format: "%K == %@", "saved", NSNumber(value: true))
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [onlyUserPlaylists, onlySavedPlaylists])
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
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
