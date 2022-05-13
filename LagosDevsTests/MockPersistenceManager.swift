//
//  MockPersistenceManager.swift
//  LagosDevsTests
//
//  Created by Yemi Gabriel on 5/13/22.
//

import Foundation
@testable import LagosDevs

class MockPersistenceManager: PersistenceManager {
    var savedProfiles: [Profile]?
    var sampleProfile: Profile?
    var sampleProfiles = Profile.sampleProfiles()
    
    func getAllProfiles() -> [Profile] {
        return Profile.sampleProfiles()
    }
    
    func saveProfiles(_ profiles: [Profile]) {
        savedProfiles = profiles
    }
    
    func getFavouriteProfiles() -> [Profile] {
        return Profile.sampleProfiles().filter{$0.isFavourited == true}
    }
    
    func toggleFavourite(profile: Profile) {
        sampleProfile = profile
        sampleProfile!.isFavourited! = !profile.isFavourited!
    }
    
    func clearAllFavourites() {
        sampleProfiles.removeAll()
    }
    
    
}
