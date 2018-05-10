//
//  VideosCollectionView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class MusicCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.90)
        alwaysBounceVertical = true
        delegate = self
        dataSource = self
        setupViews()
    }
    
    let musicCellId = "musicCellId"
    var musicArray: [Music] = []
    var lastContentOffset: CGFloat = 0
    var lastTranslation: CGFloat = 0
    var scrolledUp = false
    
    var handleScroll: ((_ isUp: Bool)->())?
    var handleSwipeStarted: (()->())?
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: musicCellId, for: indexPath) as! MusicCollectionViewCell
        cell.music = musicArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let window = UIApplication.shared.keyWindow!
        return CGSize(width: window.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
