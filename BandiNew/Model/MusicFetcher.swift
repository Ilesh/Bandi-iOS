//
//  MusicFetcher.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import CoreData

final class MusicFetcher {
    
    static let shared = MusicFetcher()
    
    private let baseYoutubeApiUrlString = "https://www.googleapis.com/youtube/v3/"
    private let youtubeApiKey = APIKeys().youtubeKey
    private let maxYoutubeResults = "14"
    private var nextPageToken: String?
    private var lastSearchQuery: String?
    private let context = CoreDataHelper.shared.getContext()
    private let songsFetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
    
    // MARK: - Playlists
    
    func fetchYoutubePlaylistDetails(playlistId: String, handler: @escaping (_ playlist: Playlist) -> Void) {
        
        let urlParameters = [
            "part" : "snippet",
            "id" : playlistId,
            "key" : youtubeApiKey
        ]
        
        guard let url = getYoutubeApiUrl(type: "playlists", parameters: urlParameters) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            do {
                guard let data = data,
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
                    let items = jsonResult["items"] as? [AnyObject]
                    else {
                        print("no json data")
                        return
                }
                
                let playlistItem = items[0]
                let playlistId = playlistItem["id"] as! String
                let snippet = playlistItem["snippet"] as! Dictionary<String, Any>
                
                let title = snippet["title"] as! String
                let description = snippet["description"] as! String
                
                self.context.perform({
                    let playlist = Playlist(context: self.context)
                    playlist.saved = false
                    playlist.title = title
                    playlist.type = "youtube"
                    playlist.orderRank = -1
                    let currentDate = Date()
                    playlist.dateCreated = currentDate
                    playlist.dateModified = currentDate
                    playlist.id = playlistId
                    playlist.playlistDescription = description
                    playlist.title = title
                    playlist.size = 0
                    CoreDataHelper.shared.appDelegate.saveContext()
                    handler(playlist)
                })
                
            } catch {
                print(error)
            }
        }).resume()
    }
    
    func fetchYoutubePlaylistSongs(playlistId: String, handler: @escaping (_ songs: [Song]?) -> Void) {
        
        var playlistSongs: [Song] = []
        
        repeat {
            
            var urlParameters = [
                "part" : "snippet",
                "maxResults" : "50",
                "playlistId" : playlistId,
                "key" : youtubeApiKey
            ]
            
            if nextPageToken != nil {
                urlParameters["pageToken"] = nextPageToken
            }
            //print(nextPageToken)
            
            let dataTaskDispatchGroup = DispatchGroup()
            dataTaskDispatchGroup.enter()
            
            guard let url = getYoutubeApiUrl(type: "playlistItems", parameters: urlParameters) else { return }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                do {
                    guard let data = data,
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
                        let items = jsonResult["items"] as? [AnyObject]
                        else {
                            print("no json data")
                            return
                    }
                    
                    if let nextPageToken = jsonResult["nextPageToken"] as? String {
                        self.nextPageToken = nextPageToken
                    } else {
                        self.nextPageToken = nil
                    }
                    
                    var tempVideoIds: [String] = []
                    for playlistItem in items {
                        let snippet = playlistItem["snippet"] as! Dictionary<String, Any>
                        let resourceId = snippet["resourceId"] as! Dictionary<String, Any>
                        let videoId = resourceId["videoId"] as! String
                        tempVideoIds.append(videoId)
                    }
                    
                    self.getVideoDetails(videoIds: tempVideoIds, handler: { songs in
                        playlistSongs.append(contentsOf: songs!)
                        dataTaskDispatchGroup.leave()
                    })
                    
                } catch {
                    print(error)
                    dataTaskDispatchGroup.leave()
                }
            }).resume()
            dataTaskDispatchGroup.wait()
        } while(nextPageToken != nil)
        
        handler(playlistSongs)
    }
    
    // MARK: - Videos
    
    func fetchYoutubeNextPage(handler: @escaping (_ music: [Song]?) -> Void) {
        guard nextPageToken != nil && lastSearchQuery != nil else { return }
        let urlParameters = [
            "q" : lastSearchQuery!,
            "pageToken" : nextPageToken!,
            "maxResults" : maxYoutubeResults,
            "part" : "snippet",
            "key" : youtubeApiKey
        ]
        
        guard let url = getYoutubeApiUrl(type: "search", parameters: urlParameters) else { return }
        getVideoList(url: url, handler: { videoIds in
            self.getVideoDetails(videoIds: videoIds, handler: handler)
        })
    }
    
    func fetchYoutube(keywords: String, handler: @escaping (_ music: [Song]?) -> Void) {
        let keywordsReplaced = keywords.replacingOccurrences(of: " ", with: "+")
        lastSearchQuery = keywordsReplaced
        let urlParameters: Dictionary<String, String> = [
            "q" : keywordsReplaced,
            "part" : "id",
            "relevanceLanguage" : "en",
            "type" : "video",
            "maxResults" : maxYoutubeResults,
            "key" : youtubeApiKey,
        ]
        
        guard let url = getYoutubeApiUrl(type: "search", parameters: urlParameters) else { return }
        getVideoList(url: url, handler: { videoIds in
            self.getVideoDetails(videoIds: videoIds, handler: handler)
        })
    }
    
    func getVideoList(url: URL, handler: @escaping (_ videoIds: [String]) -> Void) {
        var videoIds: [String] = []
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            do {
                guard let data = data,
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
                    let items = jsonResult["items"] as? [AnyObject]
                else {
                    print("no json data")
                    return
                }
                
                self.nextPageToken = jsonResult["nextPageToken"] as? String
                for item in items {
                    let id = item["id"] as! Dictionary<String, Any>
                    let videoId = id["videoId"] as? String
                    if videoId != nil {
                        videoIds.append(videoId!)
                    }
                }
                handler(videoIds)
            }
            catch {
                print("json error: \(error)")
            }
        }).resume()
    }
    
    func getVideoDetails(videoIds: [String], handler: @escaping (_ music: [Song]?) -> Void) {
        let videoIdsAppended = videoIds.joined(separator: ",")
        let urlParameters = [
            "id" : videoIdsAppended,
            "part" : "snippet,contentDetails",
            "key" : youtubeApiKey,
        ]
        
        guard let url = getYoutubeApiUrl(type: "videos", parameters: urlParameters) else { return }
        var songs: [Song] = []
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            do {
                guard let data = data,
                      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
                      let items = jsonResult["items"] as? [AnyObject]
                else {
                    print("no json data")
                    return
                }
                
                //print(jsonResult)
                for item in items {
                    let id = item["id"] as! String
                    
                    // Check if Song exists in Song cache
                    if let cachedSong = SessionData.songsCache.object(forKey: id as NSString) {
                        songs.append(cachedSong)
                        continue
                    }
                    
                    // Check if Song already exists in CoreData
                    let predicate = NSPredicate(format: "id = %d", id)
                    self.songsFetchRequest.predicate = predicate
                    do {
                        let fetchedSongs = try self.context.fetch(self.songsFetchRequest)
                        if fetchedSongs.count > 0 {
                            let song = fetchedSongs[0]
                            songs.append(song)
                            if (SessionData.songsCache.object(forKey: id as NSString) == nil) {
                                SessionData.songsCache.setObject(song, forKey: id as NSString)
                            }
                            continue
                        }
                    } catch {
                        print("No song with id found")
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
                    
                    self.context.perform({
                        let song = Song(context: self.context)
                        song.saved = false
                        song.title = title
                        song.artist = artist
                        song.id = id
                        song.liveBroadcastContent = liveBroadcastContent
                        song.length = duration
                        song.thumbnails = thumbnailsDetail
                        songs.append(song)
                        if (SessionData.songsCache.object(forKey: id as NSString) == nil) {
                            SessionData.songsCache.setObject(song, forKey: id as NSString)
                        }
                    })

                }
                
                handler(songs)
            }
            catch {
                print("json error: \(error)")
            }
        }).resume()
    }
    
    func fetchYoutubeVideoUrl(videoID: String, quality: String, handler: @escaping (_ videoURL: String?) -> Void) {
        let urlParameters = [
            "url" : "www.youtube.com/watch?v=\(videoID)",
            ]
        let requestString = "\(APIKeys().serverAddress)/?" + parametersToString(parameters: urlParameters)
        let requestURL = URL(string: requestString)
        URLSession.shared.dataTask(with: requestURL!, completionHandler: { (data, response, error) -> Void in
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] else { return }
                let directVideoURL = jsonResult["url"] as? String
                if directVideoURL == nil {
                    print("Video url for \(videoID) is nil")
                }
                handler(directVideoURL) // TODO: handle no url
            }
            catch {
                print("json error: \(error)")
            }
        }).resume()
    }
    
    // MARK: - Autocomplete Suggestions
    
    func fetchYoutubeAutocomplete(searchQuery: String, handler: @escaping (_ suggestions: [String]) -> Void) {
        let updatedSearch = searchQuery.replacingOccurrences(of: " ", with: "+")
        let urlParameters = [
            "client" : "firefox",
            "ds" : "yt",
            "q" : updatedSearch,
            "hl" : "en",
        ]
        let requestString = "https://suggestqueries.google.com/complete/search?" + parametersToString(parameters: urlParameters)
        let requestURL = URL(string: requestString)
        URLSession.shared.downloadTask(with: requestURL!, completionHandler: { (data, response, error) -> Void in
            do {
                guard let data = data else { return }
                let text = try String(contentsOf: data.absoluteURL, encoding: .utf8)
                let textData = text.data(using: .utf8)
                if let jsonResult = try JSONSerialization.jsonObject(with: textData!, options: .allowFragments) as? [Any]{
                    let suggestions = jsonResult[1] as! [String]
                    handler(suggestions)
                }
            }
            catch {
                print("error: \(error)")
            }
        }).resume()
    }
    
    // MARK: - Helpers
    
    func parametersToString(parameters: Dictionary<String, String>) -> String {
        return (parameters.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
    }
    
    func getYoutubeApiUrl(type: String, parameters: Dictionary<String, String>) -> URL? {
        let urlString = baseYoutubeApiUrlString + type + "?" + parametersToString(parameters: parameters)
        return URL(string: urlString)
    }
    
}
