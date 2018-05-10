//
//  QueueEditAlertController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/8/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class QueueEditAlertController: UIAlertController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    func setup() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Alert canceled")
        })
        let newLinkAction = UIAlertAction(title: "New Queue Link", style: .default, handler: { action in
            print("New link requested")
        })
        let newLinkAction2 = UIAlertAction(title: "New Queue Link", style: .default, handler: { action in
            print("New link requested")
        })
        
        addAction(newLinkAction2)
        addAction(newLinkAction)
        addAction(cancelAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
