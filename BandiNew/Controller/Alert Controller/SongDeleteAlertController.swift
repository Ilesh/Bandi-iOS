//
//  SongDeleteAlertController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 8/4/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SongDeleteAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    var willDisappear: (()->())?
    var deletePressed: (()->())?
    
    func setup() {
        self.message = "Deleting a song also deletes it from all playlists"
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Alert canceled")
        })
        let deleteAction = UIAlertAction(title: "Delete Song", style: .destructive, handler: { action in
            self.deletePressed?()
        })
        
        addAction(deleteAction)
        addAction(cancelAction)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        willDisappear?()
    }
    
}
