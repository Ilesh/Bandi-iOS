//
//  SongDeleteAlertController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 8/4/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class DeleteAlertController: UIAlertController {
    
    init(message: String, actionName: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.message = message
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Alert canceled")
        })
        let deleteAction = UIAlertAction(title: actionName, style: .destructive, handler: { action in
            self.deletePressed?()
        })
        
        addAction(deleteAction)
        addAction(cancelAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var willDisappear: (()->())?
    var deletePressed: (()->())?
    
    override func viewWillDisappear(_ animated: Bool) {
        willDisappear?()
    }
    
}
