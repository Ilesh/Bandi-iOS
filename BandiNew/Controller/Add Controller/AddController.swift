//
//  AddController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/6/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AddController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissSelf))
        navigationItem.leftBarButtonItem = cancelBarButton
        
        title = "Add to"
        setupViews()
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addToTableView.reloadData()
    }
    
    var song: Song?
    
    lazy var songPreviewView: SongPreviewView = {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let view = SongPreviewView(frame: CGRect(x: 0, y: statusBarHeight + 44, width: UIScreen.main.bounds.width, height: 175))
        view.song = song
        return view
    }()
    
    lazy var addToTableView: AddSongToTableView = {
        let tv = AddSongToTableView(frame: .zero, style: .plain)
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
        tv.librarySelected = { isSelected in
            self.showDone(isSelected)
        }
        tv.addPlaylist = {
            guard let nav = self.navigationController else { return }
            let addPlaylistController = AddPlaylistController(style: .plain)
            let addPlaylistNav = CustomNavigationController(rootViewController: addPlaylistController)
            nav.present(addPlaylistNav, animated: true, completion: nil)
        }
        tv.scrolled = { offset in
            let maxScrollOffset: CGFloat = 175
            if offset > 102 {
                self.setSongPreviewHeight(height: 73)
            }
            else if offset < 0 {
                self.setSongPreviewHeight(height: maxScrollOffset)
            }
            else {
                self.setSongPreviewHeight(height: maxScrollOffset - offset)
            }
        }
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let doneView: UIButton = {
        let view = UIButton()
        view.backgroundColor = Constants.Colors().primaryColor
        view.setTitle("DONE", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        view.titleLabel?.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var showingDoneConstraint = doneView.heightAnchor.constraint(equalToConstant: 55)
    lazy var hidingDoneConstraint = doneView.heightAnchor.constraint(equalToConstant: 0)
    
    func setSongPreviewHeight(height: CGFloat) {
        songPreviewView.frame.size = CGSize(width: songPreviewView.frame.width, height: height)
        let maxScrollOffset: CGFloat = 102
        let alpha = 1 - ((height - maxScrollOffset) / maxScrollOffset)
        songPreviewView.blurView.alpha = alpha
    }
    
    func setupViews() {
        view.addSubview(songPreviewView)
        view.addSubview(addToTableView)
        view.addSubview(doneView)
        
        NSLayoutConstraint.activate([
            doneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            doneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            showingDoneConstraint,
            
            addToTableView.topAnchor.constraint(equalTo: songPreviewView.bottomAnchor),
            addToTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addToTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addToTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        doneView.addTarget(self, action: #selector(addToPlaylists), for: .touchUpInside)
    }
    
    func showDone(_ show: Bool) {
        doneView.isHidden = !show
        if show {
            hidingDoneConstraint.isActive = false
            showingDoneConstraint.isActive = true
        } else {
            showingDoneConstraint.isActive = false
            hidingDoneConstraint.isActive = true
        }
        addToTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: show ? 55 : 0, right: 0)
        self.view.layoutIfNeeded()
    }
    
    @objc func addToPlaylists() {
        let playlists = addToTableView.getSelectedPlaylists()
        CoreDataHelper.shared.getContext().performAndWait({
            playlists.forEach({ playlist in
                playlist.insertSongAtEnd(song: self.song!)
            })
            song?.setSaved(saved: true, retain: true)
            CoreDataHelper.shared.appDelegate.saveContext()
        })
        dismissSelf()
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Theme
extension AddController: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.tableBackgroundColor
    }
}
