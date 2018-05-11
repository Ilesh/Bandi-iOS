//
//  Music.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class Song: NSObject/*, NSCoding */{

    var title: String?
    var artist: String?
    var album: String?
    var parentId: String?
    var dateAdded: String?
    
    let id: Dictionary<String, Any>?
    let liveBroadcastContent: String?
    let duration: String?
    let thumbnails: Dictionary<String, Any>?

    var thumbnailImages: Dictionary<String, UIImage>?
    
    init(title: String, artist: String, album: String = "", parentId: String = "", dateAdded: String = "",
         id: Dictionary<String, Any>, liveBroadcastContent: String, duration: String, thumbnails: Dictionary<String, Any>) {
        self.title = title
        self.artist = artist
        self.album = album
        self.parentId = parentId
        self.dateAdded = dateAdded
        self.id = id
        self.liveBroadcastContent = liveBroadcastContent
        self.duration = duration
        self.thumbnails = thumbnails
    }
    
    typealias CompletionHandler = (Bool) -> Void
    
    func getThumbnails(completionHandler: CompletionHandler) {
        do {
            self.thumbnailImages = [
                "small" : try UIImage(data: Data(contentsOf: URL(string: thumbnails!["small"] as! String)!)),
                //"wide" : try UIImage(data: Data(contentsOf: URL(string: thumbnails!["wide"] as! String)!)),
                //"large" : try UIImage(data: Data(contentsOf: URL(string: thumbnails!["large"] as! String)!)),
                ] as? Dictionary<String, UIImage>
            completionHandler(true)
        } catch {
            print("image failed")
        }
    }
    
//    func encode(with aCoder: NSCoder) {
//        <#code#>
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        <#code#>
//    }
    
}
