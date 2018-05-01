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
    
    var handleScroll: ((_ isUp: Bool)->())?
    var lastContentOffset: CGFloat = 0
    var lastTranslation: CGFloat = 0
    var scrolledUp = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
        if (translation.y != lastTranslation) {
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                if !scrolledUp {
                    handleScroll?(true)
                }
                scrolledUp = true
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y) {
                if scrolledUp {
                    handleScroll?(false)
                }
                scrolledUp = false
            }
        }
        
        self.lastTranslation = translation.y
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        handleScroll?(true)
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
        handleScroll?(translation.y > 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: musicCellId, for: indexPath) as! QueueMusicCollectionViewCell
        cell.music = musicArray[indexPath.row]
        cell.removeMusic = {
            if let currentIndexPath = self.indexPath(for: cell) {
                TEMPSessionData.queueMusic.remove(at: currentIndexPath.row)
                self.musicArray.remove(at: currentIndexPath.row)
                self.deleteItems(at: [currentIndexPath])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = musicArray[sourceIndexPath.row]
        musicArray[sourceIndexPath.row] = musicArray[destinationIndexPath.row]
        musicArray[destinationIndexPath.row] = temp
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
