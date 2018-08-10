//
//  DocumentsHelper.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

final class DocumentsHelper {
    
    static let shared = DocumentsHelper()
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func saveImageToDocuments(image: UIImage, fileName: String, completionHandler: ((URL)->())?) {
        
        guard let documentsDirectory = documentsDirectory, let data = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                completionHandler?(fileURL)
                print("saved:   \(fileURL)")
            } catch {
                print(error)
            }
        }
        
    }
    
    func getImageFromDocuments(imageURL: URL) -> UIImage? {
        return UIImage(contentsOfFile: imageURL.path)
    }
    
}
