//
//  PersistedProfile.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/10/22.
//

import Foundation
import RealmSwift

class PersistedProfile: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var login: String = ""
    @objc dynamic var avatar_url: String = ""
    @objc dynamic var isFavourited: Bool = false
    
    var profileModel: Profile {
        return Profile(id: id, login: login, avatar_url: avatar_url, isFavourited: isFavourited)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
