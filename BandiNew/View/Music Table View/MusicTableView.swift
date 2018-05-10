//
//  MusicTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class MusicTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        backgroundColor = Constants.Colors().darkTableCell
        separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
        separatorColor = .black
        alwaysBounceVertical = true
        delegate = self
        dataSource = self
        allowsSelection = false
        
        tableFooterView = UIView()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: musicCellId, for: indexPath) as! MusicTableViewCell
        print("makingbad")
        cell.music = musicArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
