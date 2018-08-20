//
//  SessionData.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 6/30/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

final class SessionData {
    public static let songsCache = NSCache<NSString, Song>()
    public static let imagesCache = NSCache<NSString, UIImage>()
    public static let addToPlaylist = AddToPlaylist.shared
    
    final class AddToPlaylist {
        
        static let shared = AddToPlaylist()
        
        public var playlist: Playlist?
        public var songs: [Song] = []
        private var nProposedAdds = 0
        
        func addSongsToPlaylist() {
            CoreDataHelper.shared.getContext().performAndWait {
                self.playlist?.addSongs(songs: self.songs)
                CoreDataHelper.shared.appDelegate.saveContext()
            }
            resetAddToPlaylist()
        }
        
        func resetAddToPlaylist() {
            playlist = nil
            songs.removeAll()
            nProposedAdds = 0
        }
        
        func getProposedAdds() -> Int {
            return nProposedAdds
        }
        
        func updateProposedAdds(updateBy: Int) {
            nProposedAdds = nProposedAdds + updateBy
            NotificationCenter.default.post(name: .addToPlaylistSongsNumberChanged, object: nil)
        }
        
        func setProposedAdds(adds: Int) {
            nProposedAdds = adds
            NotificationCenter.default.post(name: .addToPlaylistSongsNumberChanged, object: nil)
        }
        
        var songsAddedString: String {
            guard let playlist = playlist else { return "" }
            let proposedCount = songs.count + nProposedAdds
            if proposedCount == 0 {
                return "Add Songs to \"\(playlist.title!)\""
            } else {
                return "Add \(proposedCount) Song\(proposedCount != 1 ? "s" : "") to \"\(playlist.title!)\""
            }
        }
    }
}

class UpNextWrapper {
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(songFinishedHandler), name: .songFinished, object: nil)
    }
    
    static let shared = UpNextWrapper()
    
    private var upNextSongs: [Song] = []
    private var currentlyPlayingIndex = -1
    
    func getUpNextSongs() -> [Song] {
        return upNextSongs
    }
    
    func setUpNextSongs(songs: [Song]) {
        upNextSongs = songs
    }
    
    func getCurrentlyPlayingIndex() -> Int {
        return currentlyPlayingIndex
    }
    
    func setCurrentlyPlayingIndex(index: Int) {
        if index >= upNextSongs.count { return }
        self.currentlyPlayingIndex = index
        NotificationCenter.default.post(name: .currentlyPlayingIndexChanged, object: nil)
    }
    
    func getCurrentSong() -> Song {
        return upNextSongs[currentlyPlayingIndex]
    }
    
    func incrementCurrentIndex() {
        let nextIndex = currentlyPlayingIndex + 1
        if nextIndex == upNextSongs.count {
            setCurrentlyPlayingIndex(index: upNextSongs.count + 1)
        } else {
            setCurrentlyPlayingIndex(index: nextIndex)
        }
    }
    
    func decrementCurrentIndex() {
        let previousIndex = currentlyPlayingIndex - 1
        if previousIndex < 0 {
            setCurrentlyPlayingIndex(index: 0)
        } else {
            setCurrentlyPlayingIndex(index: previousIndex)
        }
    }
    
    @objc func songFinishedHandler() {
        incrementCurrentIndex()
    }
    
}

