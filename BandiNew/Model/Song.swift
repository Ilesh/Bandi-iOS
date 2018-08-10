//
//  Music.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

extension Song {
    
    func setSaved(saved: Bool, retain: Bool) {
        if retain && self.saved { return }
        else {
            self.saved = saved
        }
    }
    
    func fetchAThumbnail(requestedImageType: String, completion: ((UIImage?)->())?) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageId = "\(self.id!)-\(requestedImageType)"
            
            if let image = SessionData.imagesCache.object(forKey: imageId as NSString) {
                completion?(image)
                return
            }
            
            do {
                
                guard self.thumbnails != nil &&
                    self.thumbnails![requestedImageType] != nil,
                    let imageUrl = URL(string: self.thumbnails![requestedImageType]!)
                    else {
                        completion?(nil)
                        return
                }
                
                let imageData = try Data(contentsOf: imageUrl)
                guard let image = UIImage(data: imageData) else {
                    completion?(nil)
                    return
                }
                
                SessionData.imagesCache.setObject(image, forKey: imageId as NSString)
                completion?(image)
                
            } catch {
                print(error)
                completion?(nil)
            }
            
        }
        
    }
    
}
