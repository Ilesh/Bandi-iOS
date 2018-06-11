//
//  Music.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

extension Song {
    
    func fetchThumbnail(requestedImageType: String, completionHandler: (Bool)->()) {
        
        do {
            thumbnailImages![requestedImageType] = try UIImage(data: Data(contentsOf: URL(string: thumbnails![requestedImageType]!)!))
            completionHandler(true)
            let imageTypes = ["small", "wide", "large"]
            for imageType in imageTypes {
                if imageType != requestedImageType {
                    thumbnailImages![imageType] = try UIImage(data: Data(contentsOf: URL(string: thumbnails![imageType]!)!))
                }
            }
            if (MusicFetcher.songsCache.object(forKey: id! as NSString) == nil) {
                MusicFetcher.songsCache.setObject(self, forKey: id! as NSString)
            }
        } catch {
            print("thumbnail image fetching error")
            completionHandler(false)
        }
    }
}
