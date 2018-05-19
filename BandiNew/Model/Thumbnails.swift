//
//  Thumbnails.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/14/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import Foundation

class Thumbnails: NSObject, NSCoding {
    
    let smallThumbnail: Thumbnail
    let wideThumbnail: Thumbnail
    let largeThumbnail: Thumbnail
    
    init(smallThumbnail: Thumbnail, wideThumbnail: Thumbnail, largeThumbnail: Thumbnail) {
        self.smallThumbnail = smallThumbnail
        self.wideThumbnail = wideThumbnail
        self.largeThumbnail  = largeThumbnail
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(smallThumbnail, forKey: "smallThumbnail")
        aCoder.encode(wideThumbnail, forKey: "wideThumbnail")
        aCoder.encode(largeThumbnail, forKey: "largeThumbnail")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let smallThumbnail = aDecoder.decodeObject(forKey: "smallThumbnail") as! Thumbnail
        let wideThumbnail = aDecoder.decodeObject(forKey: "wideThumbnail") as! Thumbnail
        let largeThumbnail = aDecoder.decodeObject(forKey: "largeThumbnail") as! Thumbnail
        self.init(smallThumbnail: smallThumbnail, wideThumbnail: wideThumbnail, largeThumbnail: largeThumbnail)
    }
    
}
