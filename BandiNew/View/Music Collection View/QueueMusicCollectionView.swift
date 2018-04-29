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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: musicCellId, for: indexPath) as! QueueMusicCollectionViewCell
        cell.music = musicArray[indexPath.row]
        cell.handleRemoveButtonTapped = {
            if let currentIndexPath = self.indexPath(for: cell) {
                TEMPSessionData.queueMusic.remove(at: currentIndexPath.row)
                self.musicArray.remove(at: currentIndexPath.row)
                self.deleteItems(at: [currentIndexPath])
            }
        }
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
