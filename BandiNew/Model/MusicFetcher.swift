//
//  MusicFetcher.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import Foundation

class MusicFetcher {
    
    static func fetchYoutube(apiKey: String, keywords: String, handler: @escaping (_ music: [Music]?) -> Void) {
        
        let keywordsReplaced = keywords.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.googleapis.com/youtube/v3/search?q=\(keywordsReplaced)&part=snippet&type=video&relevanceLanguage=en&order=relevance&maxResults=8&key=\(apiKey)"
        let url = URL(string: urlString)
        var music: [Music] = []
        
        // let userCredential = URLCredential(user: "user", password: "password", persistence: .permanent)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                    //print(jsonResult)
                    if let items = jsonResult["items"] as? [AnyObject]? {
                        
                        for item in items! {
                            
                            let musicPiece = Music()
                            
                            let snippetDict = item["snippet"] as! Dictionary<String, Any>
                            musicPiece.title = snippetDict["title"] as? String
                            musicPiece.artist = snippetDict["channelTitle"] as? String
                            let thumbnails = snippetDict["thumbnails"] as! Dictionary<String, Any>
                            let defaultThumbnail = thumbnails["default"] as! Dictionary<String, Any> //120 x 90
                            musicPiece.thumbnailURLString = defaultThumbnail["url"] as? String
                            
                            let idDict = item["id"] as! Dictionary<String, Any>
                            musicPiece.youtubeVideoID = idDict["videoId"] as? String
                            
                            music.append(musicPiece)
                        }
                        
                        handler(music)
                    }
                }
            }
            catch {
                print("json error: \(error)")
            }
        }).resume()
    }
    
    static func fetchYoutubeVideoUrl(address: String, videoID: String, quality: String, handler: @escaping (_ videoURL: String?) -> Void) {
        
        let videoURL = "www.youtube.com/watch?v=\(videoID)"
        let requestURL = URL(string: "\(address)/?url=\(videoURL)")
        
        URLSession.shared.dataTask(with: requestURL!, completionHandler: { (data, response, error) -> Void in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                    let directVideoURL = jsonResult["url"] as? String
                    handler(directVideoURL!)
                }
            }
            catch {
                print("json error: \(error)")
            }
        }).resume()
        
    }
    
}
