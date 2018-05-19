//
//  Thumbnail.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/14/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import Foundation

class Thumbnail: NSObject, NSCoding {
    
    let width: Int
    let height: Int
    let urlString: String
    
    init(width: Int, height: Int, urlString: String) {
        self.width = width
        self.height = height
        self.urlString = urlString
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(width, forKey: "width")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(urlString, forKey: "urlString")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let width = aDecoder.decodeObject(forKey: "width") as! Int
        let height = aDecoder.decodeObject(forKey: "height") as! Int
        let urlString = aDecoder.decodeObject(forKey: "urlString") as! String
        self.init(width: width, height: height, urlString: urlString)
    }
    
}
