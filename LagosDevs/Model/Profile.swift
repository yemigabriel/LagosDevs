//
//  Profile.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import Foundation

struct Profile: Decodable {
    let id: Int
    let login: String
    let avatar_url: String
    var isFavourited: Bool?
    
    var url: URL? {
       URL(string: avatar_url)
    }
}


extension Profile {
    var persitedProfile: PersistedProfile {
        let persistedProfile = PersistedProfile()
        persistedProfile.id = id
        persistedProfile.login = login
        persistedProfile.avatar_url = avatar_url
        return persistedProfile
    }
}

extension Profile {
    static func sampleProfiles() -> [Profile] {
        [
            Profile(id: 1, login: "wanda", avatar_url: "https://via.placeholder.com/150.png", isFavourited: true),
            Profile(id: 2, login: "stephen", avatar_url: "https://via.placeholder.com/150.png"),
            Profile(id: 3, login: "wong", avatar_url: "https://via.placeholder.com/150.png"),
            Profile(id: 4, login: "chavez", avatar_url: "https://via.placeholder.com/150.png", isFavourited: true),
            Profile(id: 5, login: "rintra", avatar_url: "https://via.placeholder.com/150.png"),
            Profile(id: 6, login: "reed", avatar_url: "https://via.placeholder.com/150.png"),
            Profile(id: 7, login: "xavier", avatar_url: "https://via.placeholder.com/150.png"),
            Profile(id: 8, login: "chthon", avatar_url: "https://via.placeholder.com/150.png")
        ]
    }
}

extension Profile: Equatable {
    
}

struct ProfileResponse: Decodable {
    let total_count: Int
    let items: [Profile]
}
