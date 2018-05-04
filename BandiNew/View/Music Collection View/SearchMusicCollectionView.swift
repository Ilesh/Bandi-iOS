//
//  SearchMusicCollectionView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchMusicCollectionView: MusicCollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        allowsSelection = true
        register(SearchMusicCollectionViewCell.self, forCellWithReuseIdentifier: musicCellId)
    }
    
    var handleMusicTapped: (()->())?
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results :("
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func showNoResults() {
        backgroundView = noResultsLabel
    }
    
    func showLoading() {
        backgroundView = loadingView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: musicCellId, for: indexPath) as! SearchMusicCollectionViewCell
        cell.music = musicArray[indexPath.row]
        cell.addMusic = {
            TEMPSessionData.queueMusic.append(cell.music!)
        }
        cell.swipeStarted = {
            self.handleSwipeStarted?()
        }
        cell.musicTapped = {
            self.handleMusicTapped?()
        }
        return cell
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
