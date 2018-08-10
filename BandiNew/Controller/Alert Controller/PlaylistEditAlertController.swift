//
//  PlaylistEditAlertController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PlaylistEditAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Alert canceled")
        })
        let shareLinkAction = UIAlertAction(title: "Share Playlist", style: .default, handler: { action in
            print("New link requested")
        })
        
        addAction(shareLinkAction)
        addAction(cancelAction)
    }
    
}
