//
//  FavouriteListVM.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/13/22.
//

import Foundation
import Combine

final class FavouriteListVM: ObservableObject {
    @Published var favouriteProfiles: [Profile] = []
    private var persistenceManager: PersistenceManager
    private var cancellables = Set<AnyCancellable>()
    
    init(persistenceManager: PersistenceManager = RealmPersistenceManager.shared) {
        self.persistenceManager = persistenceManager
    }
    
    func getFavouriteProfiles() {
        favouriteProfiles = persistenceManager.getFavouriteProfiles()
    }
    
    func removeFavourite(at index: Int) {
        var profile = favouriteProfiles[index]
        profile.isFavourited = false
        persistenceManager.toggleFavourite(profile: profile)
    }
    
    func clearAllFavourites() {
        favouriteProfiles.removeAll()
        persistenceManager.clearAllFavourites()
    }
    
}
