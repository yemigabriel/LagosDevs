//
//  UserDefaults+Extension.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/13/22.
//

import Foundation

extension UserDefaults {
    static let TOTAL_COUNT = "TOTAL_COUNT"
    
    func setProfileCount(count: Int) {
        set(count, forKey: UserDefaults.TOTAL_COUNT)
    }
    
    func getProfileCount() -> Int {
        return integer(forKey: UserDefaults.TOTAL_COUNT)
    }
}

