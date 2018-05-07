//
//  QueueMusicCollectionView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueMusicCollectionView: MusicCollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(QueueMusicCollectionViewCell.self, forCellWithReuseIdentifier: musicCellId)
    }
    
    var handleMusicRemoved: (()->())?
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results :("
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noQueueLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing Queued :O"
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func showNoResults() {
        backgroundView = noResultsLabel
    }
    
    func showNoQueue() {
        backgroundView = noQueueLabel
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: musicCellId, for: indexPath) as! QueueMusicCollectionViewCell
        cell.music = musicArray[indexPath.row]
        cell.removeMusic = {
            if let currentIndexPath = self.indexPath(for: cell) {
                TEMPSessionData.queueMusic.remove(at: currentIndexPath.row)
                self.musicArray.remove(at: currentIndexPath.row)
                self.deleteItems(at: [currentIndexPath])
                self.handleMusicRemoved?()
            }
        }
        cell.swipeStarted = {
            self.handleSwipeStarted?()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = musicArray[sourceIndexPath.row]
        musicArray.remove(at: sourceIndexPath.row)
        musicArray.insert(temp, at: destinationIndexPath.row)
        TEMPSessionData.queueMusic = musicArray
        
        UIView.performWithoutAnimation {
            performBatchUpdates({
                reloadData()
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
