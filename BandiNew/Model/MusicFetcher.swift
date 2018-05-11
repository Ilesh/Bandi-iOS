//
//  MusicFetcher.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class MusicFetcher {
    
    static let songsCache = NSCache<NSString, Song>()
    
    // First request IDs of videos then request snippet + contentDetails becuase contentDetails cant be requested with a search api request
    static func fetchYoutube(keywords: String, handler: @escaping (_ music: [Song]?) -> Void) {
        
        let apiKey = APIKeys().youtubeKey
        let baseYoutubeApiUrlString = "https://www.googleapis.com/youtube/v3/"
        let keywordsReplaced = keywords.replacingOccurrences(of: " ", with: "+")
        var videoIds: [String] = []
        var urlParameters: Dictionary<String, String>?
        var urlString: String?
        var url: URL?
        func parametersToString(parameters: Dictionary<String, String>) -> String {
            return (parameters.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }) as Array).joined(separator: "&")
        }
        
        // Get list of video Ids
        
        urlParameters = [
            "q" : keywordsReplaced,
            "part" : "id",
            "relevanceLanguage" : "en",
            "type" : "video",
            "maxResults" : "11",
            "key" : apiKey,
        ]
        urlString = baseYoutubeApiUrlString + "search?" + parametersToString(parameters: urlParameters!)
        url = URL(string: urlString!)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            do {
                if data != nil {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                        //print(jsonResult)
                        if let items = jsonResult["items"] as? [AnyObject]? {
                            for item in items! {
                                let id = item["id"] as! Dictionary<String, Any>
                                let videoId = id["videoId"] as? String
                                videoIds.append(videoId!)
                            }
                            getVideoDetails()
                        }
                    }
                } else {
                    print("no json data")
                }
            }
            catch {
                print("json error: \(error)")
            }
        }).resume()
        
        // Get details of each video and handle the resulting songs
        
        func getVideoDetails() {
            let videoIdsAppended = videoIds.joined(separator: ",")
            urlParameters?.removeAll()
            urlParameters = [
                "id" : videoIdsAppended,
                "part" : "snippet,contentDetails",
                "key" : apiKey,
            ]
            urlString = baseYoutubeApiUrlString + "videos?" + parametersToString(parameters: urlParameters!)
            url = URL(string: urlString!)
            var songs: [Song] = []
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                do {
                    if data != nil {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                            //print(jsonResult)
                            if let items = jsonResult["items"] as? [AnyObject]? {
                                for item in items! {
                                    let id  = [
                                        "type" : "youtube#video",
                                        "id" : item["id"] as! String,
                                        ]
                                    if let cachedSong = songsCache.object(forKey: id["id"]! as NSString) {
                                        songs.append(cachedSong)
                                        continue
                                    }
                                    
                                    let snippet = item["snippet"] as! Dictionary<String, Any>
                                    let liveBroadcastContent = snippet["liveBroadcastContent"] as! String
                                    if liveBroadcastContent == "live" {
                                        continue
                                    }
                                    let contentDetails = item["contentDetails"] as! Dictionary<String, Any>
                                    let thumbnails = snippet["thumbnails"] as! Dictionary<String, Any>
                                    
                                    let title = snippet["title"] as! String
                                    let artist = snippet["channelTitle"] as! String
                                    let duration = contentDetails["duration"] as! String
                                    let thumbnailsDetail = [
                                        "small" : (thumbnails["default"] as! Dictionary<String, Any>)["url"] as! String,
                                        "wide" : (thumbnails["medium"] as! Dictionary<String, Any>)["url"] as! String,
                                        "large" : (thumbnails["high"] as! Dictionary<String, Any>)["url"] as! String,
                                        ]
                                    
                                    let song = Song(title: title, artist: artist, id: id, liveBroadcastContent: liveBroadcastContent, duration: duration, thumbnails: thumbnailsDetail)
                                    songs.append(song)
                                }
                                handler(songs)
                            }
                        }
                    } else {
                        print("no json data")
                    }
                }
                catch {
                    print("json error: \(error)")
                }
            }).resume()
        }
    }
    
    static func fetchYoutubeVideoUrl(videoID: String, quality: String, handler: @escaping (_ videoURL: String?) -> Void) {
        let videoURL = "www.youtube.com/watch?v=\(videoID)"
        let requestURL = URL(string: "\(APIKeys().serverAddress)/?url=\(videoURL)")
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
