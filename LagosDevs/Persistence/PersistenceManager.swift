//
//  ProfileRepository.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/10/22.
//

import Foundation
import RealmSwift

protocol PersistenceManager {
    func getAllProfiles() -> [Profile]
    func saveProfiles(_ profiles: [Profile])
    func getFavouriteProfiles() -> [Profile]
    func toggleFavourite(profile: Profile)
    func clearAllFavourites()
}

class RealmPersistenceManager: PersistenceManager {
    static let shared = RealmPersistenceManager()
    private let realm: Realm
    
    private init() {
        realm = try! Realm()
    }
    
    func getAllProfiles() -> [Profile] {
        let persistedProfiles = realm.objects(PersistedProfile.self)
        return persistedProfiles.compactMap{$0.profileModel}
    }
    
    func saveProfiles(_ profiles: [Profile]) {
        let realm = try! Realm()
        let persistedProfiles = profiles.map{$0.persitedProfile}
        try? realm.write{
            realm.add(persistedProfiles, update: .modified)
        }
    }
    
    func getFavouriteProfiles() -> [Profile] {
        let favoriteProfiles = realm.objects(PersistedProfile.self).where {
            $0.isFavourited == true
        }
        return favoriteProfiles.compactMap{$0.profileModel}
        
    }
    
    func toggleFavourite(profile: Profile) {
        let realm = try! Realm()
        if let persistedProfile = realm.objects(PersistedProfile.self).filter("id = %@", profile.id).first {
            do {
                try realm.write {
                    persistedProfile.isFavourited = profile.isFavourited ?? false
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    func clearAllFavourites() {
        let realm = try! Realm()
        try? realm.write{
            let persistedProfiles = realm.objects(PersistedProfile.self)
            for profile in persistedProfiles {
                profile.isFavourited = false
            }
        }
    }
}
