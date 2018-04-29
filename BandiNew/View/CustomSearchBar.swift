//
//  CustomSearchBar.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar, UISearchBarDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        barStyle = .blackTranslucent
    }
    
    var connectedVideoCollectionView: MusicCollectionView?
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        MusicFetcher.fetchYoutube(apiKey: APIKeys.init().youtubeKey, keywords: text!) { (youtubeVideos) -> Void in
            if let youtubeVideos = youtubeVideos {
                DispatchQueue.main.async {
                    self.connectedVideoCollectionView?.musicArray = youtubeVideos
                    DispatchQueue.main.async {
                        self.connectedVideoCollectionView?.reloadData()
                    }
                }
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
