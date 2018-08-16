//
//  Playlist.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 6/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import Foundation

extension Playlist {

    func getSongsArray() -> [Song] {
        var songs: [Song] = []
        var currentSongNode = firstSong
        while currentSongNode != nil {
            if let song = currentSongNode?.song {
                songs.append(song)
            }
            currentSongNode = currentSongNode?.nextSong
        }
        return songs
    }
    
    // MARK: Linked List implementation for storing playlist songs
    
    func getSongNode(at index: Int) -> SongToPlaylist? {
        
        if firstSong == nil { return nil }
        
        var currentIndex = 0
        var tempSongNode: SongToPlaylist? = firstSong
        while tempSongNode?.nextSong != nil {
            if currentIndex == index { break }
            currentIndex = currentIndex + 1
            tempSongNode = tempSongNode?.nextSong
        }
        
        return tempSongNode
    }
    
    func moveSong(from: Int, to: Int) {
        
        if firstSong == nil || from == to { return }
        
        let tempSongNode = getSongNode(at: from)
        
        guard let song = tempSongNode?.song else { return }
        removeSong(at: from)
        insertSong(song: song, at: (from >= to ? to : to))
        
    }
    
    func insertSongAtStart(song: Song) {
        
        guard let songToInsert = CoreDataHelper.shared.createSongToPlaylist(song: song, playlist: self) else { return }
        songToInsert.previousSong = nil
        
        if firstSong == nil {
            firstSong = songToInsert
            lastSong = firstSong
        } else {
            songToInsert.nextSong = firstSong
            firstSong = songToInsert
        }
        
        size = size + 1
        
    }
    
    func insertSongAtEnd(song: Song) {
        
        guard let songToInsert = CoreDataHelper.shared.createSongToPlaylist(song: song, playlist: self) else { return }
        songToInsert.nextSong = nil
        
        if firstSong == nil {
            firstSong = songToInsert
            lastSong = firstSong
        } else {
            songToInsert.previousSong = lastSong
            lastSong = songToInsert
        }
        
        size = size + 1
        
    }
    
    func insertSong(song: Song, at index: Int) {
        
        if index == 0 {
            insertSongAtStart(song: song)
            return
        }
        else if index == size {
            insertSongAtEnd(song: song)
            return
        }
        
        guard let songToInsert = CoreDataHelper.shared.createSongToPlaylist(song: song, playlist: self) else { return }

        guard let tempSongNode = getSongNode(at: index - 1) else { return }
        songToInsert.nextSong = tempSongNode.nextSong
        tempSongNode.nextSong = songToInsert
        
        size = size + 1
    }
    
    func removeSongAtStart() {
        if firstSong == nil { return }
        firstSong = firstSong?.nextSong
        firstSong?.previousSong = nil
        size = size - 1
    }
    
    func removeSongAtEnd() {
        if firstSong == nil { return }
        lastSong = lastSong?.previousSong
        lastSong?.nextSong = nil
        size = size - 1
    }
    
    func removeSong(at index: Int) {
        
        if firstSong == nil { return }
        
        if index == 0 {
            removeSongAtStart()
            return
        }
        else if index == size - 1 {
            removeSongAtEnd()
            return
        }
        
        var tempSongNode: SongToPlaylist? = firstSong
        
        for _ in 0...index-1 {
            if tempSongNode == nil { break }
            tempSongNode = tempSongNode?.nextSong
        }
        
        if tempSongNode == nil || tempSongNode?.nextSong == nil {
            return
        }
        
        tempSongNode?.previousSong?.nextSong = tempSongNode?.nextSong
        
        size = size - 1
        
    }
    
    func removeAllSongs() {
        while self.size > 0 {
            self.removeSongAtStart()
        }
    }
    
    func removeSong(song: Song) {
        let songs = getSongsArray()
        for i in 0..<Int(self.size) {
            if songs[i].id == song.id {
                self.removeSong(at: i)
                break
            }
        }
    }
    
}
