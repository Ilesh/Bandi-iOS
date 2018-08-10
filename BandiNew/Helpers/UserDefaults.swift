//
//  UserDefaults.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 7/6/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    // MARK: - Saved Theme
    func setSavedTheme(value: String) {
        UserDefaults.standard.set(value, forKey: "savedTheme")
    }
    
    func getSavedTheme() -> String? {
        return string(forKey: "savedTheme")
    }
    
}
